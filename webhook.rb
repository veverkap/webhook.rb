require "sinatra"
require "sinatra/json"
require_relative "unique_id"

use Rack::RequestId

get "/" do
  json request.env.sort.to_h
end

post "/:service/" do
  status, headers, body = call env.merge("PATH_INFO" => '/', "SERVICE" => params[:service])
  [status, headers, body]
end

post "/" do
  puts request.env["SERVICE"]
  request_id = Rack::RequestId.current

  request.body.rewind  # in case someone already read it
  data = request.body.read

  if request.accept == "application/json" || request.env["CONTENT_TYPE"] == "application/json"
    data = JSON.parse(data)

    # write data to file
    File.open("requests/#{request_id}.json", 'w') do |f|
      f.write(JSON.pretty_generate(data))
    end
  end
  response = {
    accept: request.accept,
    env: environment(request.env),
    body: data
  }
  json response
end

def environment(env)
  env.reject { |k, v| k.start_with?("rack.") || k.start_with?("sinatra.") || k.start_with?("puma.") }.sort.to_h
end