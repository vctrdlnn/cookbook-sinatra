require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
set :bind, '0.0.0.0'
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

# https://github.com/lewagon/sinatra-101#share-with-the-world

get '/' do
  erb :index
end

get '/about' do
  @usernames = ['victor', 'maxime', 'julien']
  erb :about
end

get '/team/:username' do
  puts params[:username]
  "The username is #{params[:username]}"
end
