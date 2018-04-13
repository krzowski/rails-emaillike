# -- use macros as at page 112
# -- $scenario '', js: true do$ to use selenium driver to open the spec in firefox


# -- todo: write the rest of controller specs,  
# -- todo: write some specs covering the creation of users/emails/labels, and changing the session hash on, say, ajax

# test ajax email change!!! https://stackoverflow.com/questions/5679983/rspec-testing-ajax-response-should-render-a-partial

#test draft save from new_email

require "rails_helper"

feature "User creation" do
  scenario "navigating from root page as a guest" do
    create_user

    expect(page).to have_content("Signed up successfully")
    within ".account-container" do
      expect(page).to have_content("Settings")
    end
    within ".account-container" do
      expect(page).to have_content("Log out")
    end
  end
end

feature "User login/logout" do
  scenario "login from root page as a guest" do
    @user_attr = attributes_for(:user)
    @user = create(:user)
    visit root_path
    fill_in "Username", with: @user_attr[:username]
    fill_in "Password", with: @user_attr[:password]
    click_button "Log in"

    within ".account-container" do
      expect(page).to have_content("Settings")
    end
    within ".account-container" do
      expect(page).to have_content("Log out")
    end
  end

  scenario "logout from root page as a user" do   
    create_user

    visit root_path
    click_link "Log out"

    within ".guest-description" do
      expect(page).to have_content("a simpler message exchange")
    end
  end
end