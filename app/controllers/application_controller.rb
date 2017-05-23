class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	require 'csv'
	require 'open-uri'
	require 'htmlentities'
	EMAILREGEX = /.+@.+\..+/i
	EMAILREG = Regexp.new('.+@.+\..+')

	def index
		begin
			@list_upload = CSV.read(session['listfile']) if session['listfile']
		rescue Errno::ENOENT
			puts 'Error with reading file.'
			flash[:notice] = 'Error with reading file!'
		end
	end
	def scrape
		list = CSV.read(session['listfile']) if session['listfile']
		coder = HTMLEntities.new(:html4)
		@source = []
		@emails = []
		@row = []
		list.each do |row|
			begin
				if row[0].end_with?('/')
					url = row[0] + 'about'
				else
					url = row[0] + '/about'
				end
				coder = HTMLEntities.new(:html4)
				source = open(url).read
				source = coder.decode(source.force_encoding("UTF-8"))
				puts 'Source DataType: ' + source.class.to_s
				puts 'Link URL: ' + url
				@source.append(source)

			rescue Errno::ENOENT
				puts 'Page not found! Skipping...'
			rescue OpenURI::HTTPError
				puts '404 Error! Skipping...'
			end
		end
		@source.each do |source|
			email_address = source.match(/([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9._-]+)/i)
			puts 'Email Address (mailto): ' + email_address.to_s
			@emails.append(email_address)
		end
		
		

	end
	def upload
		listfile = params[:list]
		list_upload = ListUploader.new
		list_upload.cache!(listfile)
		session['listfile'] = 'public' + list_upload.url
		redirect_to '/'
	end
end