require 'sinatra'
require_relative './database.rb'

# PORT 8000 for Kubernetes backend on Toolforge
set :port, 8000

get '/' do
  'Ohai'
end

before do
  content_type 'application/json', 'charset' => 'utf-8'
  Replica.connect
end

after do
  Replica.close_connection
end
