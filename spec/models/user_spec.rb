require 'rails_helper'

RSpec.describe User, type: :model do
  
  context 'validations' do
    it 'is valid with an unique, case insensitive username and at least 6 characters-long password' do
      expect(build(:user)).to be_valid
    end

    it 'is invalid without username' do
      user = build(:user, username: nil)
      user.valid?
      expect(user.errors[:username]).to include("can't be blank")
    end

    it 'is invalid with taken, case insensitive username' do
      user = create(:user)
      user2 = build(:user, username: user.username.upcase)
      user2.valid?
      expect(user2.errors[:username]).to include("has already been taken")
    end

    it 'is invalid with password_confirmation not matching password' do
      user = build(:user, password_confirmation: 'passwddddd')
      user.valid?
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it { should have_secure_password }
    it { should validate_length_of(:password).is_at_least(6).on(:create) }
  end

  context 'associations' do
    it { should have_many(:emails).dependent(:destroy) }
    it { should have_many(:labels).dependent(:destroy) }
    it { should have_many(:drafts).dependent(:destroy) }
    it { should have_many(:contacts).dependent(:destroy) }
  end

end
