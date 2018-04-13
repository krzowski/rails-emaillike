require 'rails_helper'

RSpec.describe Email, type: :model do
  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:message) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:user_id) }
  end

  context 'associations' do
    it { should belong_to(:label) }
    it { should belong_to(:user) }
    it { should belong_to(:interlocutor) }
  end

  context 'scopes' do
    before :each do
      @first =  create(:received_email)
      @second = create(:sent_email)
      @third =  create(:sent_email, trash: true)
    end

    it "default scope doesn't contain trash" do
      expect(Email.all).to eq([@first, @second])
    end

    it 'trash scope contains only trash' do
      expect(Email.all.trash).to eq([@third])
    end

    it "sent scope contains only sent messages" do
      expect(Email.all.sent).to eq([@second])
    end

    it "received scope contains only received messages" do
      expect(Email.all.received).to eq([@first])
    end

    it "newest scope sorts messages descending by the date of creation" do
      expect(Email.all.newest).to eq([@second, @first])
    end    

    it "oldest scope sorts messages ascending by the date of creation" do
      expect(Email.all.oldest).to eq([@first, @second])
    end    
  end
end
