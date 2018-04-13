FactoryBot.define do
  factory :email do
    sequence(:title) { |i| "Title#{i}" } 
    message Faker::Matz.quote
    username "username"
    user_id 1

    factory :sent_email do
      message_type 'sent'
    end

    factory :received_email do
      message_type 'received'
    end
  end
end