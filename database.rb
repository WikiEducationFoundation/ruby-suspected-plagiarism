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


class Replica
  def self.connect(database: 'enwiki')
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
end
