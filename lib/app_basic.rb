require_relative 'cookbook'    # You need to create this file!
require_relative 'controller'  # You need to create this file!
require_relative 'router'
require 'pry-byebug'

csv_file   = File.join(__dir__, 'recipes.csv')
# binding.pry
cookbook   = Cookbook.new(csv_file)
controller = Controller.new(cookbook)

router = Router.new(controller)

# Start the app

router.run
