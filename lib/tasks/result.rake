# desc "Fetch product prices"
# task :fetch_prices => :environment do
#   require 'nokogiri'
#   require 'open-uri'
  
#   Product.find_all_by_price(nil).each do |product|
#     url = "https://www.google.co.in/#q=hello"
#     doc = Nokogiri::HTML(open(url))
#     val = doc.at_css("#resultStats").text
#     product.update_attribute(:price, price)
#   end
# end