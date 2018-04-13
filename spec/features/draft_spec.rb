require "rails_helper"

feature "Creating draft" do
  scenario "from new email form" do
    create_user 
    visit new_email_path

    expect {
      fill_in "To", with: "Something"
      fill_in "Title", with: "Something"
      fill_in "Message", with: "Something"
      click_button "Save as draft"
    }.to change(Draft, :count).by(1)

    expect(current_path).to eq(draft_path(Draft.last))
  end
end

feature "Sending draft" do
  scenario "from draft form" do
    create_user
    create(:draft, user_id: User.last.id)
    visit draft_path(Draft.last)
    fill_in "Message", with: "True"

    expect {
      click_button "Send message"
    }.to change(Draft, :count).by(-1)
    .and change(Email, :count).by(1)
    expect(current_path).to eq(email_path(Email.last))
    expect(page).to have_content("Email was sent")
  end
end
