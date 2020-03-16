require 'csv'
require_relative 'recipe'

class Cookbook
  # initializes new repository loading all recipes in a CSV file to an array
  def initialize(csv_file_path)
    @recipes = []
    @csv_file_path = csv_file_path
    CSV.foreach(@csv_file_path) do |row|
      attributes = { name: row[0], description: row[1], prep_time: row[2],
                     done: row[3], difficulty: row[4] }
      stored_recipe = Recipe.new(attributes)
      @recipes << stored_recipe
    end
  end

  def save_csv
    CSV.open(@csv_file_path, 'wb') do |csv|
      @recipes.each { |rec| csv << [rec.name, rec.description, rec.prep_time, rec.done, rec.difficulty] }
    end
  end

  # adds new recipe to the array. Recipe is an object

  def add_recipe(recipe)
    @recipes << recipe
    save_csv
  end

  # deletes a specific index in the array

  def remove_recipe(target_index)
    @recipes.delete_at(target_index)
    save_csv
  end

  def all
    @recipes
  end

  def to_done(index_to_mark)
    @recipes[index_to_mark].done = true
    save_csv
  end
end
