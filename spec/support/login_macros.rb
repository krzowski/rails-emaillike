module LoginMacros
  def create_user
    visit root_path
    click_link "Sign up now!"
    fill_in "Username", with: "Someuser"
    fill_in "Password", with: "passwd"
    fill_in "Password confirmation", with: "passwd"
    click_button "Create my account"
  end
end