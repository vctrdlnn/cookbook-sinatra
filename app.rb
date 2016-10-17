require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
require_relative 'lib/cookbook'    # You need to create this file!
require_relative 'lib/controller'  # You need to create this file!
require_relative 'lib/router'
require_relative 'lib/recipe'
set :bind, '0.0.0.0'
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

# https://github.com/lewagon/sinatra-101#share-with-the-world

csv_file   = File.join(__dir__, '/lib/recipes.csv')
# binding.pry
cookbook   = Cookbook.new(csv_file)
controller = Controller.new(cookbook)


get '/' do
  @options = {
    list: "1 - List all recipes",
    create: "2 - Create a new recipe",
    import: "3 - Import recipes from [Marmiton|Jamie Oliver]",
  }
  erb :index
end

get '/about' do
  @usernames = ['victor', 'maxime', 'julien']
  erb :about
end

get '/list' do
  # @recipe_list = @controller.list
  @all_recipes = controller.list
  erb :list
end

post '/list' do

end

get '/create' do
  erb :create
end

post '/create' do
  arguments = {name: ""}
  params.each_pair { |k, v| arguments[k.to_sym] = v }
  arguments[:done] = "true" if arguments[:done] == "on"
  cookbook.add_recipe(Recipe.new(arguments)) if arguments[:name] != ""
  redirect to('/list')
end

get '/destroy' do
  erb :destroy
end

get '/modify' do
  erb :modify
end

get '/import' do
  erb :import
end

get '/destroy/:index' do
  controller.destroy(params[:index].to_i)
  redirect to('/list')
end
