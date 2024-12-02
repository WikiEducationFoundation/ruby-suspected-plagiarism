require 'active_record'
require 'mysql2'
require 'yaml'

# This database is owned and populated as part of the `copypatrol` project.
# We just need to read from it.
DATABASE_HOST = 'qbyvyo2fbjk.svc.trove.eqiad1.wikimedia.cloud'
COPYRIGHT_DATABASE = 'copypatrol'
# turn replica.my.cnf into a yml file with `user` and `password` keys
credentials = YAML.load(File.open('cnf.yml').read)
USERNAME = credentials['trove_user']
PASSWORD = credentials['trove_password']
ITHENTICATE_USER = credentials['ithenticate_user']
ITHENTICATE_PASSWORD = credentials['ithenticate_password']

class Database
  def self.connect
    ActiveRecord::Base.establish_connection(
      adapter: 'mysql2',
      database: COPYRIGHT_DATABASE,
      encoding: 'utf8',
      host: DATABASE_HOST,
      username: USERNAME,
      password: PASSWORD
    )
  end

  def self.close_connection
    ActiveRecord::Base.connection.close
  end
end

# Database schema is documented at https://phabricator.wikimedia.org/T293688
# WikiEducationDashboard only uses these columns: lang, project, diff, ithenticate_id

class CopyrightDiffs < ActiveRecord::Base
  self.table_name = 'diffs'
  self.primary_key = 'diff_id'
  self.ignored_columns = []

  def rev_user_text
    # This column can contain non-UTF-8 characters but we need it
    self[:rev_user_text].force_encoding('UTF-8')
  end
  
  def page_title
    # This ensures the page title will be able to convert cleanly to JSON.
    self[:page_title].force_encoding('UTF-8')
  end
end
