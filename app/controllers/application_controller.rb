class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	EMAILREGEX = /.+@.+\..+/i
	
	def index
		@list_upload = CSV.read(session['listfile']) if session['listfile']
	end
	def scrape
		
	end
	def upload

	end
end