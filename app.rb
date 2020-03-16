# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
require_relative 'cookbook'
require_relative 'recipe'

csv_file = File.join(__dir__, 'recipes.csv')
cookbook = Cookbook.new(csv_file)

# set :bind, '0.0.0.0'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  @recipes = cookbook.all
  erb :index
end

get '/new_recipe' do
  erb :new_recipe
end

get '/delete' do
  @recipes = cookbook.all
  erb :delete
end

post '/recipes' do
  new_recipe = Recipe.new(params)
  cookbook.add_recipe(new_recipe)
  redirect '/'
end

post '/deleting' do
  cookbook.remove_recipe(params[:user_option].to_i)
  redirect '/'
end
