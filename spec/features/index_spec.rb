require "rails_helper"

describe "website" do 
	describe "/" do 
		it "should give an iterface to users" do 
			visit "/"
            expect(page).to have_link("PIZZA REVIEWS")
            click_link("PIZZA REVIEWS")       
            expect(page).to have_link("PIZZA REVIEWS")
            expect(page).to have_current_path(root_path)
		end
		

		it "should give users directions to use the webapp" do 
			visit "/"
            expect(page).to have_content("Directions")                  
            expect(page).to have_content("1. Enter the Name of the Resturant and number of reviews, if there be no results, try adding new york at the end of the name, if there be an error from abrupt URLs, follow steps 2 - 4 to try a different solution")
            expect(page).to have_content("4. Enter the URL Unique ID(Dont enter normal name in URI optional field) in the optional field and and number of reviews you want in the search box below, please leave the name field blank")
		end


		it "gives users search capability" do 
			visit "/"
			expect(page).to have_content("SEARCH AN NYC PIZZA SHOP")
            fill_in "name", :with => "pizzarte new york"
            fill_in "number", :with => "3"
            click_button("Search", match: :first)
            expect(page).to have_content("Review: Very very good. Casual atmosphere though it would not look strange to dress up a bit.")
		end		

		it "gives users optional search with URI" do 
			visit "/"
			expect(page).to have_content("SEARCH AN NYC PIZZA SHOP")
            fill_in "optional", :with => "pizzarte-new-york"
            fill_in "number", :with => "3"
            click_button("Search", match: :first)
            expect(page).to have_content("Review: Very very good. Casual atmosphere though it would not look strange to dress up a bit.")
		end	

	end


end