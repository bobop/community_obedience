require 'sinatra'
require 'open-uri'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require './config/environments' #database configuration 
require 'rdiscount'
# MODELS
require './models/cluster'
require './models/area'

enable :sessions

set :haml, :format => :html5

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
end

get '/' do
  # @areas = Area.where(day: 7)
  @areas = Area.where(day: Date.today.mday)
  @clusters = @areas.map{ |a| a.cluster }.uniq
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

# AREAS
get '/admin/areas' do
  @areas = Area.order('day ASC')
  @area = Area.new
  @clusters = Cluster.all
  haml :areas
end
get '/admin/areas/:id/edit' do |id|
  @area = Area.find(id)
  @clusters = Cluster.all
  haml :area_form
end
post '/admin/areas' do
  @area = Area.new(params[:area])
  if @area.save
    redirect '/admin/areas', notice: 'area has been saved successfully.'
  else
    redirect '/admin/areas', error: "Sorry, there was an error: #{@area.errors.full_messages.join('. ')}"
  end
end 
put '/admin/areas/:id' do |id|
  @area = Area.find(id)
  if @area.update(params[:area])
    redirect '/admin/areas', notice: 'area was updated successfully.'
  else
    redirect '/admin/areas', error: "Sorry, there was an error: #{@area.errors.full_messages.join('. ')}"
  end
end 