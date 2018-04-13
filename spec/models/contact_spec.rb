require 'rails_helper'

RSpec.describe Contact, type: :model do
  context 'validations' do
    it "is invalid with non-unique, case insensitive name" do
      first = create(:contact)
      second = build(:contact, name: first.name.upcase)
      expect(second).not_to be_valid
    end
  end

  context 'associations' do
    it { should belong_to(:user) }
  end

  context 'scopes' do
    it "has a default scope of ascending order by case-insensitive name" do
      a = create(:contact, name: "first")
      b = create(:contact, name: 'FArst')
      c = create(:contact, name: 'Fiso')

      expect(Contact.all).to eq([b, a, c])
    end
  end
end
