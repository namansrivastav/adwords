require "rubygems"
require 'nokogiri'
require 'open-uri'
require 'csv' 

class HomesController < ApplicationController

	def index
		@homes = Home.all
		respond_to do |format|
			format.html
			format.csv{ send_data @homes.to_csv }
		end
	end

	def new 
		@home = Home.new
	end

	def create
		@home = Home.new(document_params)
		if @home.save
			
			#Importing data from csv file
			csv_text = File.read(@home.data.path)
			csv = CSV.parse(csv_text, :headers => true)
			#byebug
			csv.each do |row|

				@filedet = Filedet.new
				url = "https://www.google.co.in/search?q="+row[0]
				@doc = Nokogiri::HTML(open(url))

				@filedet.getword = row[0]
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

				@filedet.home_id = @home.id
				#page detail
				#@filedet.pagedetail = PGconn.escape_bytea(@doc.to_s)
				@filedet.save

			end
		redirect_to action: 'index',notice: "File has been uploaded"
	else
		redirect_to action: 'new', notice: "File uploading fail"
	end


		# @home = Home.new(document_params)
		# if @home.save
		# 	redirect_to action: 'index',notice: "File has been uploaded"
		# else
		# 	redirect_to action: 'new', notice: "File uploading fail"
		# end
	end

	def show
		# @filedet = Filedet.find_by_home_id(params[:id])
		@filedet = Filedet.where(home_id: params[:id])
		# byebug
		# url = "https://www.google.co.in/#q=hello"
		# @doc = Nokogiri::HTML(open(url))
		
		# #top adword
		# top_ad = []
		# @doc.css('div#tads ol li cite').each do |item|
		# 	top_ad<<item.text
		# end

		# @filedet.topadurl = top_ad

		# #right adword
		# right_ad = []
		# @doc.css('#mbEnd ol li cite').each do |item|
		# 	right_ad<<item.text
		# end
		# @filedet.rightadurl = right_ad

		# #right adword
		# normal_url = []
		# @doc.css("#ires ol li cite").each do |item|
		# 	normal_url<<item.text
		# end
		# @filedet.normalurl = normal_url

		# #total searches
		# total_search = @doc.css("#resultStats").text
		# @filedet.totalsearch = total_search

		# #page detail
		# #@filedet.pagedetail = PGconn.escape_bytea(@doc.to_s)
		# @filedet.save


		#@filedet = Home.order(:username)
		# respond_to do |format|
		# 	format.html
		# 	format.csv{ send_data @filedet.to_csv }
		# end

		#Importing data from csv file

		# csv_text = File.read('/home/inveera/Desktop/detail.csv')
		# csv = CSV.parse(csv_text, :headers => true)
		# byebug
		# csv.each do |row|
		# 	Filedet.create!(row.to_hash)
		# 	byebug
		# end
		# byebug
		# normal_url = []
		# url = 'http://www.google.com/search?q=car+stereo'
		# @doc = Nokogiri::HTML(open(url))
		# # byebug
		# val = @doc.css("#resultStats")
		
		# @doc.css('div#tads ol li cite').each do |item|
		# 	 byebug
		# 	# link.text
		# 	end
		# @doc.css("#ires ol li cite").each do |item|
		# 	normal_url<<item.text
		# 	end
		# normal_url.size.times do|n|
		# 	puts normal_url[n]
		# end

		# byebug

		# puts val.text
		#byebug
		# @home = Home.find(params[:id])
		# @content = File.read(@home.data.path)
		# @cont = @content.split("#")
		# @cont.size.times do|c|
		# 	puts @cont[c]
		# end
		#byebug
		# send_data(@document.file_contents,
		# 	type: @document.content_type,
		# 	filename: @document.filename)
		# @home  = Home.find(params[:id])
		# csv_text = File.read(@home.data.path)
		# csv = CSV.parse(csv_text, :headers => true)
		# byebug
		# csv.each do |row|
		# 	# Filedet.create!(row.to_hash)
		# 	byebug
		#end
end

def search
	val = params.require(:home).permit(:word)
	@filedet = Filedet.first
	#@filedet.search_record(@filedet.topadurl)
	#byebug
	#Filedet.search_record(@filedet)

	#byebug
	# @filedet.size.times do|f|
	# 	where("totalsearch ILIKE ?", "%#{'ab'}%")
	# end

	#@getid = Filedet.find(params[:id])
	# val[:word]
	#@filedet.topadurl
	
end

private 

def document_params
	params.require(:home).permit(:username, :data)
end

end
