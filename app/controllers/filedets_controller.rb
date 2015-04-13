class FiledetsController < ApplicationController
		def create
		@filedet = Filedet.new
		url = "https://www.google.co.in/#q=hello"
		@doc = Nokogiri::HTML(open(url))
		
		#top adword
		top_ad = []
		@doc.css('div#tads ol li cite').each do |item|
			top_ad<<item.text
		end

		@filedet.topadurl = top_ad

		#right adword
		right_ad = []
		@doc.css('#mbEnd ol li cite').each do |item|
			right_ad<<item.text
		end
		@filedet.rightadurl = right_ad

		#right adword
		normal_url = []
		@doc.css("#ires ol li cite").each do |item|
			normal_url<<item.text
		end
		@filedet.normalurl = normal_url

		#total searches
		total_search = @doc.css("#resultStats").text
		@filedet.totalsearch = total_search

		@filedet.save
	end
end
