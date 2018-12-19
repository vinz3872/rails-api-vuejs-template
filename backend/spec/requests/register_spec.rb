require 'rails_helper'

RSpec.describe 'POST /register', type: :request do
  let(:url) { '/register' }
  let(:params) do
    {
      user: {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        address: {
          street_address: Faker::Address.full_address,
          secondary_address: Faker::Address.secondary_address,
          city: 'Paris',
          state: Faker::Address.state,
          country: Faker::Address.country,
          postcode: Faker::Address.postcode,
        },
        password: 123456,
        phone: Faker::PhoneNumber.phone_number,
      }
    }
  end

  context 'when user is unauthenticated' do
    before { post url, params: params }

    it 'returns 201' do
      expect(response.status).to eq 201
    end

    it 'returns a new user' do
      binding.pry
      expect(response).to match_response_schema('user')
    end
  end

  context 'when user already exists' do
    before do
      FactoryBot.create(:user, email: params[:user][:email])
      post url, params: params
    end

    it 'returns bad request status' do
      expect(response.status).to eq 422
    end

    it 'returns validation errors' do
      expect(JSON.parse(response.body)['errors']['email'].first).to eq('has already been taken')
    end
  end
end