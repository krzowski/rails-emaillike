require 'rails_helper'

RSpec.describe Label, type: :model do

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
    it { should validate_length_of(:name).is_at_most(10) }
  end

  describe 'default scope' do
    let!(:first) { create(:label) }
    let!(:second) { create(:label) }
    it 'orders by ascending name' do
      expect(Label.all).to eq([first, second])
    end
  end

  context 'associations' do
    it { should have_many(:emails).dependent(:nullify) }
    it { should belong_to(:user) }
  end
end
