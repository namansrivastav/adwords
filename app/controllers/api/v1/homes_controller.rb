module Api
	module V1
		class Api::V1::HomesController< ApplicationController
			#doorkeeper_for :all
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
					respond_with @filedet

				end
					redirect_to action: 'index',notice: "File has been uploaded"
				else
					redirect_to action: 'new', notice: "File uploading fail"
				end
			end

			def show
				respond_with Filedet.where(home_id: params[:id])
			end

			def search
				val = params.require(:home).permit(:word)
				@filedet = Filedet.first
				byebug
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