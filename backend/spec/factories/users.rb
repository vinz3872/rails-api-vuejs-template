FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    address { {
      street_address: Faker::Address.full_address,
      secondary_address: Faker::Address.secondary_address,
      city: 'Paris',
      state: Faker::Address.state,
      country: Faker::Address.country,
      postcode: Faker::Address.postcode,
    } }
    password { 123456 }
    password_confirmation { 123456 }
    phone { Faker::PhoneNumber.phone_number }
  end
end
