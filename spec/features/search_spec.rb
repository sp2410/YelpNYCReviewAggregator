require "rails_helper"

describe "search" do 
	describe "/search" do 
		it "should give users proper reviews for valid input" do 
			visit "/"
			expect(page).to have_content("SEARCH AN NYC PIZZA SHOP")
                  fill_in "name", :with => "pizzarte new york"
                  fill_in "number", :with => "2"
                  click_button("Search", match: :first)
                  expect(page).to have_content("Review: Very very good. Casual atmosphere though it would not look strange to dress up a bit.")                  
                  expect(page).to have_content("Overall Average Rating 4.0 star rating")
		end

		it "should give users 20 reviews for valid URL identifier but number number of reviews" do 
			visit "/"
			expect(page).to have_content("SEARCH AN NYC PIZZA SHOP")
                  fill_in "name", :with => "pizzarte new york"
                  fill_in "number", :with => ""
                  click_button("Search", match: :first)                  
                  expect(page).to have_content("Review:", count: 20)            
		end
		

		it "should give users proper reviews for valid optional input" do 
			visit "/"
			expect(page).to have_content("SEARCH AN NYC PIZZA SHOP")
                  fill_in "optional", :with => "pizzarte-new-york"
                  fill_in "number", :with => "2"
                  click_button("Search", match: :first)
                  expect(page).to have_content("Review: Very very good. Casual atmosphere though it would not look strange to dress up a bit.")                  
                  expect(page).to have_content("Overall Average Rating 4.0 star rating")
		end


		it "should give no results for empty inputs" do 
			visit "/"
			expect(page).to have_content("SEARCH AN NYC PIZZA SHOP")
                  fill_in "name", :with => ""
                  fill_in "number", :with => ""
                  click_button("Search", match: :first)
                  expect(page).to have_no_content("Review:")
		end	

            it "should give alert messages if the inputs are empty" do 
                  visit "/"
                  expect(page).to have_content("SEARCH AN NYC PIZZA SHOP")
                  fill_in "name", :with => ""
                  fill_in "number", :with => ""
                  click_button("Search", match: :first)
                  expect(page).to have_content("No Average Rating Found")
                  expect(page).to have_content("No reviews were found, please change the search parameters")
            end

            it "should give user message if optional field is not used" do 
                  visit "/"
                  expect(page).to have_content("SEARCH AN NYC PIZZA SHOP")
                  fill_in "optional", :with => ""
                  fill_in "number", :with => ""
                  click_button("Search", match: :first)
                  expect(page).to have_content("No Average Rating Found")
                  expect(page).to have_content("No reviews were found, please change the search parameters")
            end   	
	end


end