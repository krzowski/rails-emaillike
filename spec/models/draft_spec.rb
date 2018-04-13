require 'rails_helper'

RSpec.describe Draft, type: :model do
  context 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:user_id) }
  end

  context 'associations' do
    it { should belong_to(:user) }
  end

  context 'scopes' do
    before :each do
      @first =  create(:draft)
      @second = create(:draft)
    end

    it 'newest scope returns draft by descending date of creation' do
      expect(Draft.all.newest).to eq([@second, @first])
    end

    it 'oldest scope returns draft by ascending date of creation' do
      expect(Draft.all.oldest).to eq([@first, @second])
    end
  end
end
