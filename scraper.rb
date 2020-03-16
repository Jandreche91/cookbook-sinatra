require 'nokogiri'
require 'open-uri'
require_relative 'recipe'

class Scraper
  def initialize; end

  def get_doc(url)
    doc = Nokogiri::HTML(open(url), nil, 'utf-8')
    doc
  end

  def get_doc_of_recipe(card)
    link_to_recipe = card.css('.recipe-card-link').attribute('href').value
    if link_to_recipe[0] == 'h'
      get_doc(link_to_recipe)
    else
      get_doc('https://www.marmiton.org' << link_to_recipe)
    end
  end

  def card_scraper(card)
    attribs = {}
    attribs[:name] = card.search('.recipe-card__title').text.strip
    recipe_doc = get_doc_of_recipe(card)
    attribs[:prep_time] = card.search('.recipe-card__duration__value').text
    attribs[:difficulty] = recipe_doc.search('.recipe-infos__level').text.strip
    attribs[:description] = card.search('.recipe-card__description').text.strip
    Recipe.new(attribs)
  end

  def scraper_service(doc)
    results = []
    doc.search('.recipe-card').first(5).each do |card|
      results << card_scraper(card)
    end
    results
  end
end
