FactoryBot.define do
  factory :contact do |f|
    f.sequence(:name) { |n| "#{Faker::Name.name} #{n}" }
  end
end