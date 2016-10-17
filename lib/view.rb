require 'pry-byebug'

class View
  def display_all_recipes(cookbook)
    html_string = "<p>-- Here are all your recipes --</p><ul>"
    cookbook.all.each_with_index do |recipe, index|
      recipe.done ? tested = "X" : tested = " "
      html_string += "<li>#{index}. [#{tested}] #{recipe.name} (#{recipe.cooking_time}) - #{recipe.description}</li>"
    end
    html_string += "</li>"
  end

  def select_recipe_index(cookbook)
    puts "--\nEnter index of the recipe you want:"
    answer = gets.chomp
    check_valid_index?(answer, cookbook.all) ? answer.to_i : nil
  end

  def ask_new_recipe_name
    puts "Enter recipe name:"
    gets.chomp
  end

  def input_changes_recipe(recipe) # SHOULD IT BE IN VIEW OR CONTROLLER
    puts "You are about to modify #{recipe.name}"
    display_possible_changes
    answer = gets.chomp.to_i
    input_new_value(answer)
  end

  def display_possible_changes
    puts "--"
    puts "What do you want to modify: "
    puts "1. Mark as done"
    puts "2. Change description"
    puts "3. Change cooking time"
  end

  def input_new_value(answer)
    new_args = {}
    case answer
    when 1 then new_args[:done] = true
    when 2 then
      puts "Enter new description"
      new_args[:description] = gets.chomp
    when 3 then
      puts "Enter new cooking time:"
      new_args[:cooking_time] = gets.chomp
    else puts "Wrong input - please type 1, 2 or 3"
    end
    new_args
  end

  def ask_new_recipe_description
    puts "Enter description of the recipe:"
    gets.chomp
  end

  def wrong_index
    puts "This is not a recipe index"
  end

  def select_ingredient
    puts "Import recipes for which ingredient ?"
    gets.chomp
  end

  def display_select_web_recipe(recipe_list)
    start_index = 0
    diplay_X_results(recipe_list, start_index, recipe_list.length)
    puts "----\nEnter index of recipe to add to your cookbook"
    answer = gets.chomp
    check_valid_index?(answer, recipe_list) ? answer.to_i :   nil
  end

  def diplay_X_results(recipe_list, start_index, num)
    for index in (start_index...start_index+num)
      puts "#{index} - #{recipe_list[index].name} (cook time = #{recipe_list[index].cooking_time}): #{recipe_list[index].description}" unless index >= recipe_list.length
    end
  end

  def check_valid_index?(response, array_test)
    if !response.match(/\d+/).nil? && response.to_i < array_test.length
      true
    else
      wrong_index
      false
    end
  end

  def confirm_import(recipe)
    puts "#{recipe.name} has been imported to cookbook"
  end
end
