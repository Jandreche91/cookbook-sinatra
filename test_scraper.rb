require 'nokogiri'
require 'open-uri'
require_relative 'recipe'


def get_doc(url)
  doc = Nokogiri::HTML(open(url), nil, 'utf-8')
  doc
end

def scrap(search_term)
  url = "https://www.marmiton.org/recettes/recherche.aspx?type=all&aqt=#{search_term}"
  doc = get_doc(url)
  attributes = {}
  results = []
    doc.search('.recipe-card').first(5).each do |card|
      attributes[:name] = card.search('.recipe-card__title').text.strip
      link_to_recipe = card.css('.recipe-card-link').attribute('href').value
      recipe_doc = get_doc(link_to_recipe[0] == 'h' ? link_to_recipe : "https://www.marmiton.org" << link_to_recipe)
      attributes[:prep_time] = card.search('.recipe-card__duration__value').text
      attributes[:difficulty] = recipe_doc.search('.recipe-infos__level').text.strip
      attributes[:description] = card.search('.recipe-card__description').text.strip
      results << Recipe.new(attributes)
    end

    p results
  end

  scrap('fraise')
