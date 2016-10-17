require_relative 'view'
require_relative 'recipe'
require_relative 'parsing'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    @cookbook.all
  end

  def create
    recipe_args = {name: @view.ask_new_recipe_name, description: @view.ask_new_recipe_description}
    @cookbook.add_recipe(Recipe.new(recipe_args))
  end

  def destroy(index)
    @cookbook.remove_recipe(index) unless index.nil?
  end

  def modify
    self.list
    index = @view.select_recipe_index(@cookbook)
    new_args = @view.input_changes_recipe(@cookbook.get_recipe(index))
    @cookbook.modify_recipe(index, new_args)
    #TODO: let modify several parameters
  end

  def scrap
    search_term = @view.select_ingredient.downcase
    web_recipe_list = Parsing.import_from_site("marmiton", search_term)
    list_index = @view.display_select_web_recipe(web_recipe_list)
    unless list_index.nil?
      @cookbook.add_recipe(web_recipe_list[list_index])
      @view.confirm_import(web_recipe_list[list_index])
    end
  end



end
