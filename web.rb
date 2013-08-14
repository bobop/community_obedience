require 'sinatra'
set :haml, :format => :html5

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
end

get '/' do
  # "Hello, world"
  haml :index
end