class YelpReviews

	require 'nokogiri'
	require 'open-uri'
	require 'cgi'

	attr_accessor :errors
	
	def initialize

				
		# Main Search URL
		@reviews = Hash.new	
		@rating = Array.new	
		@errors = false
		@url = "https://www.yelp.com/biz/"

			

		# User Agent to proxy for 503 errors
		@user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
	end


	#Refactoring with a class method for DRY
	def self.prep(params)

		if params[:name].present?
			#Getting the search URL for the pizza resturant
			searchurl = "https://www.yelp.com/search?find_desc="
			# Ensure space is taken care of
			searchurl = searchurl + CGI.escape(params[:name]) + "&find_loc=New+York,+NY"

			#Store data in an array
			buffer = Array.new

			url = ""

			#URL to be concatenated with the url found form search
			baseurl = "https://www.yelp.com"

			#Proxy user agent
			user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"		
				

			#Error checking
			begin
				docurl = Nokogiri::HTML(open(searchurl, 'User-Agent' => user_agent), nil, "UTF-8")
				

				docurl.css(".biz-name.js-analytics-click").each do |i|
					buffer << i[:href].to_s	
				end

				if buffer.size > 0
					url = baseurl + buffer[0]
				end

				return url

			rescue OpenURI::HTTPError => e
			  @errors = true
			  return url
			end	
		end
	end

	def search(params)

		# Edge Case check
		if params[:name].present?
		
		#Error checking
			begin
				@url =  self.class.prep(params)

				if @url.size > 20

					@doc = Nokogiri::HTML(open(URI.encode(@url), 'User-Agent' => @user_agent), nil, "UTF-8")
						

					#Storing each review and given rating
					@doc.css(".review-content").each do |i|
						@reviews.store((i.css("p").text).to_s, (i.css(".offscreen").attr('alt')).to_s)		
					end

					#Edge Cases
					if (params[:number].present?) and (params[:number].to_i > 0) and (!@reviews.empty?)
						return @reviews.to_a[0..((params[:number]).to_i - 1)]
					elsif (params[:number].present?) and (params[:number].to_i == 0) and (!@reviews.empty?)
						return @reviews.to_a[0]
					end					
				end

				return @reviews.to_a

			#Rescue block
			rescue OpenURI::HTTPError => e
			  @errors = true
			  return @reviews.to_a
			end			

		elsif (params[:optional].present?) and !(params[:name].present?)
			begin

				@url =  @url + params[:optional]

				@doc = Nokogiri::HTML(open(URI.encode(@url), 'User-Agent' => @user_agent), nil, "UTF-8")
							
				#Storing each review and given rating
				@doc.css(".review-content").each do |i|
					@reviews.store((i.css("p").text).to_s, (i.css(".offscreen").attr('alt')).to_s)		
				end
				#Edge Cases
				if (params[:number].present?) and (params[:number].to_i > 0) and (!@reviews.empty?)
					return @reviews.to_a[0..((params[:number]).to_i - 1)]
				elsif (params[:number].present?) and (params[:number].to_i == 0) and (!@reviews.empty?)
					return @reviews.to_a[0]
				end				
					
				return @reviews.to_a

			rescue OpenURI::HTTPError => e
			  @errors = true
			  return @reviews.to_a
			end	

		end


	end	


	def getavg(params)
		
		#Edge case handling
		if params[:name].present?
							
			begin

				@url =  self.class.prep(params)	

				if @url.size > 20					
					
					@doc = Nokogiri::HTML(open(URI.encode(@url), 'User-Agent' => @user_agent), nil, "UTF-8")
									
					@rating << (@doc.css(".rating-very-large").attr('title').to_s) if @doc.css(".rating-very-large")
														
				end

				return @rating	
				
			rescue OpenURI::HTTPError => e
			  @errors = true
			  return @rating	
			end			

		elsif (params[:optional].present?) and !(params[:name].present?)

			begin
				@url =  @url + params[:optional]
				@doc = Nokogiri::HTML(open(URI.encode(@url), 'User-Agent' => @user_agent), nil, "UTF-8")
				@rating << (@doc.css(".rating-very-large").attr('title').to_s) if @doc.css(".rating-very-large")
			
				return @rating		
				
			rescue OpenURI::HTTPError => e
			  @errors = true
			  return @rating	
			end	
		end			
	end	



end