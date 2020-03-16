# frozen_string_literal: false

require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
require 'pry-byebug'
require_relative 'cookbook'
require_relative 'recipe'
require_relative 'scraper'

csv_file = File.join(__dir__, 'recipes.csv')
cookbook = Cookbook.new(csv_file)
scraper = Scraper.new
results_from_web = nil

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

post '/from_web' do
  # binding.pry
  input_temp_location = params[:user_input]
  complement = input_temp_location
  url = "https://www.marmiton.org/recettes/recherche.aspx?type=all&aqt=#{complement.to_s}"
  doc = scraper.get_doc(url)
  results_from_web = scraper.scraper_service(doc)
  redirect '/recipes_from_web'
end

get '/recipes_from_web' do
  @results = results_from_web
  erb :recipes_from_web

  # binding.pry
end

post '/add_from_web' do
  option = params[:user_option].to_i
  cookbook.add_recipe(results_from_web[option])
  redirect '/'
end

post '/deleting' do
  cookbook.remove_recipe(params[:user_option].to_i)
  redirect '/'
end
