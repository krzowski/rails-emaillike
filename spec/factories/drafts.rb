FactoryBot.define  do
  factory :draft do
    username "Addressee"
    sequence(:title) { |i| "draft#{i}"} 
    user_id 1
  end
end