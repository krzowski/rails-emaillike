FactoryBot.define do
  factory :label do
    sequence(:name) { |i| "Label#{i}" }
  end
end