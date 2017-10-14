require 'nokogiri'
require 'HTTParty'

class YeffsyAlert

  def self.print_alert(url, searched_element)
    new(url, searched_element).build_message
  end

  def initialize(url, searched_element)
    @url              = url
    @searched_element = searched_element
  end

  def build_message
    elements.map { |x| x.text.gsub!(/\s+/, " ").strip }.map.with_index { |x, index| x.chars.unshift("[#{index + 1}] ").join }
  end

  private

  attr_reader :url, :searched_element

  def page
    HTTParty.get(url)
  end

  def parsed_page
    Nokogiri::HTML(page)
  end

  def elements
    @elements ||= parsed_page.css(searched_element)
  end

end

bikes = [
  { name: "Racing",   url: "https://www.yt-industries.com/uk/detail/index/sArticle/1243/sCategory/508" },
  { name: "Pro",      url: "https://www.yt-industries.com/uk/detail/index/sArticle/1242/sCategory/508" },
  { name: "Standard", url: "https://www.yt-industries.com/uk/detail/index/sArticle/1248/sCategory/508" }
]

jeffsy_pro_elem = "div[class='row no-margin-bottom variant row-eq-height active']"

bikes.each do |bike|
  puts bike[:name].capitalize
  puts YeffsyAlert.print_alert(bike[:url], jeffsy_pro_elem)
  puts "---------------------"
end










