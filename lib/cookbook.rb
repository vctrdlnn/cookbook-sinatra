require 'csv'
require 'pry-byebug'
require 'open-uri'
require 'nokogiri'


class Cookbook
  attr_accessor :csv_file, :url

  def initialize(csv_file)
    # TODO: Add csv file extraction and store into the book of recipe
    @recipes = []
    @csv_file = csv_file
    @recipes = csv_to_cookbook(@csv_file)
  end

  def all
    @recipes
  end

  def get_recipe(index)
    @recipes[index]
  end

  def add_recipe(recipe)
    @recipes << recipe
    cookbook_to_csv(@csv_file, @recipes)
  end

  def remove_recipe(recipe_id)
    @recipes.delete_at(recipe_id)
    cookbook_to_csv(@csv_file, @recipes)
    @recipes
  end

  def modify_recipe(recipe_id, new_args)
    @recipes[recipe_id].done = new_args[:done] if new_args[:done] #GET NICER WAY OF DOING
    @recipes[recipe_id].cooking_time = new_args[:cooking_time] if new_args[:cooking_time]
    @recipes[recipe_id].description = new_args[:description] if new_args[:description]
    cookbook_to_csv(@csv_file, @recipes)
  end

  private

  def csv_to_cookbook(csv_file, array_of_recipes = [])
    CSV.foreach(csv_file) do |csv|
      recipe_args = { name: csv[0], description: csv[1], cooking_time: csv[2], done: csv[3], difficulty: csv[4] }
      array_of_recipes << Recipe.new(recipe_args)
    end
    array_of_recipes
  end

  def cookbook_to_csv(csv_file, array_of_recipes)
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    CSV.open(csv_file, "wb", csv_options) do |csv|
      array_of_recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.cooking_time, recipe.done, recipe.difficulty]
      end
    end
  end


end
