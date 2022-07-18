require 'sinatra'
require_relative './database.rb'

# PORT 8000 for Kubernetes backend on Toolforge
set :port, 8000

before do
  content_type 'application/json', 'charset' => 'utf-8'
  Database.connect
end

after do
  Database.close_connection
end

get '/' do
  'Ohai'
end

get '/suspected_diffs' do
  CopyrightDiffs.last(100).to_json
end


