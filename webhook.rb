require "sinatra"
require "sinatra/json"
require_relative "unique_id"

use Rack::RequestId

get "/" do
  json message: "Hello World"
end

post "/" do
  request_id = Thread.current[:request_id].to_s

  request.body.rewind  # in case someone already read it
  data = JSON.parse request.body.read

  # write data to file
  File.open("requests/#{request_id}.json", 'w') do |f|
    f.write(JSON.pretty_generate(data))
  end

  json data
end