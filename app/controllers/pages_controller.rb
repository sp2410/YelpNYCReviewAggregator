class PagesController < ApplicationController
	require 'yelp_reviews.rb'

	def index


	end

	def search		
		@newpizza = YelpReviews.new		
		@newpizza.getavg(params)

		if !@newpizza.errors
			@avg = @newpizza.getavg(params)
		else
			flash[:alert] =  "error"
		end

		@newpizza1 = YelpReviews.new		
		@newpizza1.search(params)	

		if !@newpizza1.errors
			@items = @newpizza1.search(params)	
		else
			flash[:alert] =  "error"
		end
	end

	
end
