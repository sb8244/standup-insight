FactoryGirl.define do
  factory :group do
    title { Faker::Lorem.sentence }
  end
end
