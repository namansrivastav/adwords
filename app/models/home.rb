class Home < ActiveRecord::Base
	has_many :filedets ,dependent: :destroy
	belongs_to :user

	def self.to_csv
		CSV.generate do|csv|
			csv<< column_names
			all.each do |home|
				csv<< home.attributes.values_at(*column_names)
			end
		end
	end 

	has_attached_file :data

	#mount_uploader :data
	# validates_presence_of :data
	validates_attachment :data, :presence => true,
  	:content_type => { :content_type => "text/csv" }

	#do_not_validate_attachment_file_type :data
	#validate_attachment_file_name :data , matches: [*\.(csv)]
	# validate_attachment_file_name :data, accept: 'text/csv'
  	#validates_attachment_content_type :data, :content_type => /\A*\/.csv\Z/ , :message => "Invalid file"
# 	def initialize(params = {})
# 		file = params.delete(:file)
# 		super
# 		if file
# 			self.filename = sanitize_filename(file.original_filename)
# 			self.content_type = file.content_type
# 			self.file_contents = file.read
# 		end
# 	end
# 	private
# 	def sanitize_filename(filename)
#     # Get only the filename, not the whole path (for IE)
#     # Thanks to this article I just found for the tip: http://mattberther.com/2007/10/19/uploading-files-to-a-database-using-rails
#     return File.basename(filename)
# end
end
