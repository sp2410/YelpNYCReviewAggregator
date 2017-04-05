require 'rails_helper'
require 'yelp_reviews.rb'

describe "yelpreviews" do 
	
	it "should create a new YelpReviews instance"  do
		yelpreview = YelpReviews.new()
		expect(yelpreview).to be_an_instance_of(YelpReviews)		
	end

	it "should return search result as array of reviews"  do
		params = {name: 'bleecker street pizza new york' , number: '2'}

		yelpreview = YelpReviews.new()		
		ret = yelpreview.search(params)	

		expect(ret).to be_an_instance_of(Array)

		#Note: the corresponding index will change if new ratings are posted
		expect(ret[1].to_s).to  include("Oh Bleeker St Pizza, you may have saved my drunken life")
	end

	it "should return search result as array of reviews for optional parameter"  do
		params = {optional: 'bleecker-street-pizza-new-york' , number: '2'}

		yelpreview = YelpReviews.new()		
		ret = yelpreview.search(params)

		expect(ret).to be_an_instance_of(Array)

		#Note: the corresponding index will change if new ratings are posted
		expect(ret[1].to_s).to  include("Oh Bleeker St Pizza, you may have saved my drunken life")
	end

	it "should give average for a pizza shop"  do
		params = {name: 'bleecker street pizza new york' , number: '2'}

		yelpreview = YelpReviews.new()		
		ret = yelpreview.getavg(params)
		
		expect(ret).to be_an_instance_of(Array)		
		expect(ret.to_s).to  include("4.0 star rating")


	end

	it "should return errors for incorrect pizza shop"  do
		params = {optional: 'bleecker sastasareet-pi  azz423a-new-york' , number: '2'}

		yelpreview = YelpReviews.new()		
		ret = yelpreview.search(params)
		expect(yelpreview.errors).to eq true

	end

	it "should return no results for incorrect pizza shop"  do
		params = {name: 'bleecker sastasareet-pi  azz423a-new-york' , number: '2'}

		yelpreview = YelpReviews.new()		
		ret = yelpreview.search(params)
		expect(ret.size).to eq 0
		

	end


end

