require 'active_record'
require 'mysql2'
require 'yaml'

# This database is owned and populated by the `eranbot` tool.
# We just need to read from it.
COPYRIGHT_DATABASE = 's51306__copyright_p'
# turn replica.my.cnf into a yml file with `user` and `password` keys
credentials = YAML.load(File.open('cnf.yml').read)
USERNAME = credentials['user']
PASSWORD = credentials['password']
ITHENTICATE_USER = credentials['ithenticate_user']
ITHENTICATE_PASSWORD = credentials['ithenticate_password']

class Database
  def self.connect
    ActiveRecord::Base.establish_connection(
      adapter: 'mysql2',
      database: COPYRIGHT_DATABASE,
      encoding: 'utf8',
      host: "tools.labsdb",
      username: USERNAME,
      password: PASSWORD
    )
  end

  def self.close_connection
    ActiveRecord::Base.connection.close
  end
end

class CopyrightDiffs < ActiveRecord::Base
  self.table_name = 'copyright_diffs'
  self.ignored_columns = ['report']

  def page_title
    self[:page_title].force_encoding('UTF-8')
  end
end
