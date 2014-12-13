require 'rest-client'
require 'sinatra'
require 'sinatra/flash'
require 'shotgun'
require 'slim'
require 'json'

enable :sessions

get '/' do
  slim :form
end

get '/index' do
  if (params['title']).length <= 1
    flash[:notice] = "Search string must be atleast 2 characters."
    redirect '/'
  else
    movies = RestClient.get "http://www.omdbapi.com/?s=#{(params['title']).gsub(" ","+")}"
    @movies = JSON.parse(movies.body)
    slim :index
  end
end

get '/title/:imdbID' do
  movies = RestClient.get "http://www.omdbapi.com/?i=#{params['imdbID']}"
  @movie = JSON.parse(movies.body)
  slim :show
end
