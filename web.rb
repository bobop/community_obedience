require 'sinatra'
require 'open-uri'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require './config/environments' #database configuration 
# MODELS
require './models/cluster'

enable :sessions

set :haml, :format => :html5

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
end

get '/' do
  # "Hello, world"
  haml :index
end

# CLUSTERS
get '/admin/clusters' do
  @clusters = Cluster.all
  haml :clusters
end
get '/admin/clusters/:id/edit' do |id|
  @cluster = Cluster.find(id)
  haml :cluster_form
end
post '/admin/clusters' do
  @cluster = Cluster.new(params[:cluster])
  if @cluster.save
    redirect '/admin/clusters', notice: 'Cluster has been saved successfully.'
  else
    redirect '/admin/clusters', error: "Sorry, there was an error: #{@cluster.errors.full_messages.join('. ')}"
  end
end 
put '/admin/clusters/:id' do |id|
  @cluster = Cluster.find(id)
  if @cluster.update(params[:cluster])
    redirect '/admin/clusters', notice: 'Cluster was updated successfully.'
  else
    redirect '/admin/clusters', error: "Sorry, there was an error: #{@cluster.errors.full_messages.join('. ')}"
  end
end 