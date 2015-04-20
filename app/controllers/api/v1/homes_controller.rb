module Api
	module V1
		class Api::V1::HomesController< ApplicationController
			before_action :doorkeeper_authorize!

			respond_to :json
			def index
				respond_with Home.all
			end

			def new 
				respond_with Home.new
			end

			def create
				@home = Home.new(document_params)
				@home.user_id = current_user.id
				if @home.save

				#Importing data from csv file
				csv_text = File.read(@home.data.path)
				#csv = CSV.parse(csv_text, :headers => true)
				csv = CSV.parse(csv_text)
				$i = 0
				while $i < csv[0].size  do
					get_word = csv[0][$i] 
					
					# csv.each do |row|
					@filedet = Filedet.new
					url = "https://www.google.co.in/search?q="+get_word
					@doc = Nokogiri::HTML(open(url))

					# 	@filedet.getword = row[0]
					@filedet.getword = get_word
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
						@filedet.user_id = current_user.id
						#page detail
						@filedet.pagedetail = PGconn.escape_bytea(@doc.to_s)
						@filedet.save

						$i +=1
					end

				end
				respond_with @home

			end

			def show
				@id = params[:id]
				if !params[:home].nil?
					if !params[:home][:findword].nil?
						@filedet = Filedet.where("('%#{params[:home][:findword]}%' ~~*^ ANY (topadurl) OR '%#{params[:home][:findword]}%' ~~*^ ANY (rightadurl)) AND (home_id= '#{@id}')")
					end
					if !params[:home][:findurl].nil?
						@filedet = Filedet.where("'%#{params[:home][:findurl]}%' ~~*^ ANY (normalurl) AND home_id='#{@id}'")
					end
				else
					@filedet = Filedet.where(home_id: params[:id])				
				end
				respond_with @filedet
			end

			private 

			def document_params
				params.require(:home).permit(:username, :data)
			end

			def current_user
				@current_user ||=User.find(doorkeeper_token.resource_owner_id)
			end 

		end
	end
end