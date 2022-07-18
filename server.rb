require 'sinatra'
require 'json'
require 'xmlrpc/client'
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

get '/ithenticate_report_url/:ithenticate_id' do
  server = XMLRPC::Client.new2("https://api.ithenticate.com/rpc")
  login_response = server.call('login', username: ITHENTICATE_USER, password: ITHENTICATE_PASSWORD)
  # response looks like:
  # {"status"=>200, "response_timestamp"=>#<XMLRPC::DateTime:0x000056454cce3eb0 @year=2022, @month=7, @day=18, @hour=21, @min=54, @sec=51>, "sid"=>"111104a89ab1111487225acfc111b37ce1111", "api_status"=>200}
  return { 'error' => 'ithenticate login failed' }.to_json unless login_response['status'] == 200
  sid = login_response['sid']
  report_response = server.call('report.get', { id: params['ithenticate_id'], sid: sid })
  # reponse looks like:
  # {"api_status"=>200, "view_only_url"=>"https://api.ithenticate.com/view_report/3EDCBA72-06E5-11ED-8F49-827867B98040", "status"=>200, "response_timestamp"=>#<XMLRPC::DateTime:0x000056454c4b2700 @year=2022, @month=7, @day=18, @hour=22, @min=1, @sec=59>, "report_url"=>"https://api.ithenticate.com/report/88006634/similarity", "sid"=>"...", "view_only_expires"=>#<XMLRPC::DateTime:0x000056454cea31d8 @year=2022, @month=7, @day=18, @hour=22, @min=21, @sec=59>}
  return report_response['view_only_url']
end


