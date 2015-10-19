# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
    ratings = arg1.split(', ')
    Movie.all_ratings.each do |my_ratings|
        if(ratings.include?(my_ratings))
            check "ratings_#{my_ratings}"
        else
            uncheck "ratings_#{my_ratings}"
        end
    end
    click_button 'Refresh'
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
    ratings = arg1.split(', ')
    result = true
    
    all('td[2]').each do |rating_displayed|
        if(!ratings.include?(rating_displayed.text))
            result = false
        end
    end
    expect(result).to be_truthy
end

Then /^I should see all of the movies$/ do
    all('tbody/tr').size.should == Movie.all.size
end

When /^I sort the movies by "(.*?)"$/ do |button_link|
  click_on button_link
end

Then /^I should see the movies sorted by "(.*?)"$/ do |name|
    result = true
    sorted_movies = Movie.order(name)
    i = 0
    
    all('td[1]').each do |actual_name|
        if(actual_name.text != sorted_movies[i].title)
            result = false
        end
        i += 1
    end
    expect(result).to be_truthy
end









