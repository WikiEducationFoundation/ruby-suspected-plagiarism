require 'sinatra'
require_relative './replica.rb'

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
