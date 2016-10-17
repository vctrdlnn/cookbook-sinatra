class Recipe
  attr_reader :name, :difficulty
  attr_accessor :description, :cooking_time, :done

  def initialize(arguments)
    @name = arguments[:name]
    @description = arguments[:description]
    @cooking_time = arguments[:cooking_time] || "n/a"
    @done = to_boolean(arguments[:done]) || false
    @difficulty = arguments[:difficulty] || "n/a"
  end

  def to_boolean(str)
    str == 'true'
  end


  # def modify(new_args)
  #   new_args.each_pair { |k, v| @k = v }
  # end

  def mark_as_done
    @done = true
  end
end
