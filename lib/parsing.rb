# encoding: utf-8
require 'i18n'

class Parsing

  def self.import_from_site(site, search_term)

    recipe_array = []
    possible_sites = self.new.sites

    url = possible_sites[site.to_sym][:url] + search_term

    # TODO: ASK FOR HELP ON THE CURL
    # curl url > search_term + '.html'
    # file = search_term + '.html'

    html_file = open(url)
    html_doc = Nokogiri::HTML(html_file, nil, 'utf-8')

    recipe_array = case site
    when "jamie" then self.jamie_parsing(html_doc)
    when "marmiton" then self.marmiton_parsing(html_doc)
    end
  end

  def sites
    sites =
    {
      jamie:
        {
        name: "jamie",
        url: "http://www.jamieoliver.com/search/?s=",
        xpath: "//*[@id='search-isotope']/div",
        classnod: ".col-lg-3.col-sd-4.col-md-4.col-sm-4.col-xs-6.result.all.recipe"
        },
      marmiton:
        {
        name: "marmiton",
        url: "http://www.marmiton.org/recettes/recherche.aspx?aqt=",
        xpath: "",
        classnod: ".m_titre_resultat"
        }
    }
  end

  def self.jamie_parsing(html_doc)
    recipe_args ={}
    recipe_array = []
    html_doc.search(".col-lg-3.col-sd-4.col-md-4.col-sm-4.col-xs-6.result.all.recipe").each do |element|
      recipe_args[:name] = element.children[1].children[1].attributes["alt"].value
      recipe_args[:description] = element.children[1].attributes["href"].value
      recipe_array << Recipe.new(recipe_args)
    end
    recipe_array
  end

  def self.marmiton_parsing(html_doc)

    I18n.enforce_available_locales = false
    I18n.available_locales = [:fr]

    recipe_args ={}
    recipe_array = []
    html_doc.search(".m_contenu_resultat").each do |element|
      unless element.search(".m_titre_resultat").children[1].attribute('title').nil?
        recipe_args[:name] = I18n.transliterate(element.search(".m_titre_resultat").children[1].attribute('title').value)
        recipe_args[:description] = I18n.transliterate(element.search('.m_texte_resultat').text)
        element.search(".m_detail_time").children.length < 3 ? recipe_args[:cooking_time] = "n/a" : recipe_args[:cooking_time] = element.search(".m_detail_time").children[3].text
        recipe_args[:difficulty] = I18n.transliterate(element.search(".m_detail_recette").children[1].text)
        recipe_array << Recipe.new(recipe_args) unless recipe_args[:name].nil? || recipe_args[:description].nil?
      end
    end
    recipe_array
  end
end
