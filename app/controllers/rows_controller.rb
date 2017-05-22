class RowsController < ApplicationController
	def index
		@rows = Row.all
	end
	def show
		@rows = Row.all
	end
	
end