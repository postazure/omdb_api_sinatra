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
  movies = RestClient.get "http://www.omdbapi.com/?s=#{(params['title']).gsub(" ","+")}&y=#{params['year']}"
  @movies = JSON.parse(movies.body)

  if @movies["Error"] == "Movie not found!"
    flash[:notice] = "No Results"
    redirect '/'
  elsif params['title'].length <= 1
    flash[:notice] = "Title is to short to search!"
    redirect '/'
  else
    slim :index
  end
end

get '/title/:imdbID' do
  movies = RestClient.get "http://www.omdbapi.com/?i=#{params['imdbID']}"
  @movie = JSON.parse(movies.body)
  slim :show
end
