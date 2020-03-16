class Recipe
  attr_reader :name, :description, :prep_time, :done, :difficulty
  attr_writer :done
  def initialize(attributes = {})
    @name = attributes[:name]
    @description = attributes[:description]
    @prep_time = attributes[:prep_time]
    @done = false
    @difficulty = attributes [:difficulty]
  end
end
