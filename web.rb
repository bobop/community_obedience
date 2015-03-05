require 'sinatra'
require 'open-uri'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require './config/environments' #database configuration
# MODELS
require './models/province'
require './models/nation'
require './models/cluster'
require './models/area'

enable :sessions

set :haml, :format => :html5

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
end

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    # @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'admin']
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [ENV['ADMIN_USERNAME'], ENV['ADMIN_PASSWORD']]
  end
end

get '/' do
  unless params[:all] == 'true'
    @nations = Nation.where(day: Date.today.mday)
    @areas = Area.where(day: Date.today.mday)
    @clusters = @areas.map{ |a| a.cluster }.uniq
  end
  haml :index
end

# CLUSTERS
get '/admin/clusters' do
  protected!
  @clusters = Cluster.all
  @nav = 'c'
  haml :clusters
end
get '/admin/clusters/:id/edit' do |id|
  protected!
  @cluster = Cluster.find(id)
  @nav = 'c'
  haml :cluster_form
end
post '/admin/clusters' do
  protected!
  @cluster = Cluster.new(params[:cluster])
  if @cluster.save
    redirect '/admin/clusters', notice: 'Cluster has been saved successfully.'
  else
    redirect '/admin/clusters', error: "Sorry, there was an error: #{@cluster.errors.full_messages.join('. ')}"
  end
end 
put '/admin/clusters/:id' do |id|
  protected!
  @cluster = Cluster.find(id)
  if @cluster.update(params[:cluster])
    redirect '/admin/clusters', notice: 'Cluster was updated successfully.'
  else
    redirect '/admin/clusters', error: "Sorry, there was an error: #{@cluster.errors.full_messages.join('. ')}"
  end
end 

# AREAS
get '/admin/areas' do
  protected!
  @areas = Area.order('day ASC')
  @area = Area.new
  @clusters = Cluster.all
  @nav = 'a'
  haml :areas
end
get '/admin/areas/:id/edit' do |id|
  protected!
  @area = Area.find(id)
  @clusters = Cluster.all
  @nav = 'a'
  haml :area_form
end
post '/admin/areas' do
  protected!
  @area = Area.new(params[:area])
  if @area.save
    redirect '/admin/areas', notice: 'area has been saved successfully.'
  else
    redirect '/admin/areas', error: "Sorry, there was an error: #{@area.errors.full_messages.join('. ')}"
  end
end 
put '/admin/areas/:id' do |id|
  protected!
  @area = Area.find(id)
  if @area.update(params[:area])
    redirect '/admin/areas', notice: 'area was updated successfully.'
  else
    redirect '/admin/areas', error: "Sorry, there was an error: #{@area.errors.full_messages.join('. ')}"
  end
end 

# PROVINCES
get '/admin/provinces' do
  protected!
  @provinces = Province.all
  @nav = 'p'
  haml :provinces
end
get '/admin/provinces/:id/edit' do |id|
  protected!
  @province = Province.find(id)
  @nav = 'p'
  haml :province_form
end
post '/admin/provinces' do
  protected!
  @province = Province.new(params[:province])
  if @province.save
    redirect '/admin/provinces', notice: 'Province has been saved successfully.'
  else
    redirect '/admin/provinces', error: "Sorry, there was an error: #{@province.errors.full_messages.join('. ')}"
  end
end 
put '/admin/provinces/:id' do |id|
  protected!
  @province = Province.find(id)
  if @province.update(params[:province])
    redirect '/admin/provinces', notice: 'Province was updated successfully.'
  else
    redirect '/admin/provinces', error: "Sorry, there was an error: #{@province.errors.full_messages.join('. ')}"
  end
end 

# NATIONS
get '/admin/nations' do
  protected!
  @nations = Nation.order('day ASC')
  @nation = Nation.new
  @provinces = Province.all
  @nav = 'n'
  haml :nations
end
get '/admin/nations/:id/edit' do |id|
  protected!
  @nation = Nation.find(id)
  @provinces = Province.all
  @nav = 'n'
  haml :nation_form
end
post '/admin/nations' do
  protected!
  @nation = Nation.new(params[:nation])
  if @nation.save
    redirect '/admin/nations', notice: 'nation has been saved successfully.'
  else
    redirect '/admin/nations', error: "Sorry, there was an error: #{@nation.errors.full_messages.join('. ')}"
  end
end 
put '/admin/nations/:id' do |id|
  protected!
  @nation = Nation.find(id)
  if @nation.update(params[:nation])
    redirect '/admin/nations', notice: 'nation was updated successfully.'
  else
    redirect '/admin/nations', error: "Sorry, there was an error: #{@nation.errors.full_messages.join('. ')}"
  end
end 