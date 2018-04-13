require "rails_helper"

feature "create email" do
  scenario "from new email form" do
    create_user
    visit new_email_path

    expect {
      fill_in "To", with: "Something"
      fill_in "Title", with: "Something"
      fill_in "Message", with: "Something"
      click_button "Send message"
    }.to change(Email, :count).by(1)
    expect(current_path).to eq(email_path(Email.last))
    expect(page).to have_content("Email was sent")
  end

  scenario "from quick response form" do 
    create_user
    create(:received_email, user_id: User.last.id)
    visit email_path(Email.last)

    expect {
      fill_in "email_message", with: "A response"
      click_button "Send"
    }.to change(Email, :count).by(1)
    expect(current_path).to eq(email_path(Email.last))
  end
end

feature "access email" do
  scenario "through regular get request" do
    create_user
    create(:sent_email, user_id: User.last.id)
    visit email_path(Email.last)

    expect(page).to have_content(Email.last.message)
  end

  scenario "through ajax" do
    create_user
    create(:sent_email, user_id: User.last.id, message: "Firstmessage")
    create(:sent_email, user_id: User.last.id, message: "Secondmessage")
    visit sent_path

    expect(page).to have_content("Date - newest")

    within ".right-email" do
      expect(page).to have_no_content("Firstmessage")
      expect(page).to have_no_content("Secondmessage")
    end

    click_link "emailThumb1"
    within ".right-email" do
      expect(page).to have_content("Secondmessage")
    end

    click_link "emailThumb2"
    within ".right-email" do
      expect(page).to have_content("Firstmessage")
    end
  end
end

feature "sort emails list" do
  scenario "change sorting from default descending to ascending" do
    create_user
    create(:received_email, user_id: User.last.id, message: "Firstmessage")
    create(:received_email, user_id: User.last.id, message: "Secondmessage")
    visit root_path
    
    within '#emailThumb1' do
      expect(page).to have_content("Secondmessage")
    end
    within '#emailThumb2' do
      expect(page).to have_content("Firstmessage")
    end

    find('.sorting-toggle-label').click
    click_link 'Date - oldest'

    within '#emailThumb1' do
      expect(page).to have_content("Firstmessage")
    end
    within '#emailThumb2' do
      expect(page).to have_content("Secondmessage")
    end
  end
end

feature "change label" do
  scenario "change label and associated emails collection from labeled path" do
    create_user
    label1 = create(:label, user_id: User.last.id)
    label2 = create(:label, user_id: User.last.id)
    email1 = create(:sent_email, user_id: User.last.id, label_id: label1.id)
    email2 = create(:sent_email, user_id: User.last.id, label_id: label1.id)
    email3 = create(:sent_email, user_id: User.last.id, label_id: label2.id)

    visit root_path
    click_link "#{label1.name}"
    expect(page).to have_content("#{email1.title}")
    expect(page).to have_content("#{email2.title}")
    expect(page).to have_no_content("#{email3.title}")

    click_link "emailThumb1"
    find('.email-activities-icons').find('.fa-ellipsis-h').click
    find('#email-change-label').click
    within '.email-label-options' do
      click_link "#{label2.name}"
    end
    expect(page).to have_content("Label was assigned")

    expect(page).to have_no_content("#{email1.title}")
    expect(page).to have_content("#{email2.title}")
    expect(page).to have_content("#{email3.title}")
  end

  scenario "remove label" do
    create_user
    label1 = create(:label, user_id: User.last.id)
    email1 = create(:sent_email, user_id: User.last.id, label_id: label1.id)

    visit email_path(email1)
    find('.email-activities-icons').find('.fa-ellipsis-h').click
    find('#email-change-label').click
    within '.email-label-options' do
      click_link "Remove label"
    end

    expect(page).to have_content("Label was removed")
  end
end

feature "email navigation", js: true do
  scenario "change email with the use of arrows" do
    create_user
    email1 = create(:sent_email, user_id: User.last.id)
    email2 = create(:sent_email, user_id: User.last.id)
    email3 = create(:sent_email, user_id: User.last.id)
    
    visit sent_path
    visit email_path(email2)

    expect(page).to have_content("#{email1.title}")
    expect(page).to have_content("#{email2.title}")
    expect(page).to have_content("#{email3.title}")

    within '.email-received-subject' do
      expect(page).to have_content("#{email2.title}")
    end

    find('#prevEmail').click

    within '.email-received-subject' do
      expect(page).to have_content("#{email3.title}")
    end

    find('#nextEmail').click
    find('#nextEmail').click
    within '.email-received-subject' do
      expect(page).to have_content("#{email1.title}")
    end    
  end
end