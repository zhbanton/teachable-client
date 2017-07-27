require 'spec_helper'

RSpec.describe TeachableClient::User do
  it 'exists' do
    expect(TeachableClient::User).not_to be nil
  end
  describe '.register' do
    it 'registers a user' do
      VCR.use_cassette('user_register') do
        user = TeachableClient::User.register(email: 'foo@foo.com', password: 'password', password_confirmation: 'password')
        expect(user.email).to eql('foo@foo.com')
      end
    end
  end
  describe '.authenticate' do
    it 'authenticates a user' do
      VCR.use_cassette('user_authenticate') do
        user = TeachableClient::User.authenticate(email: 'foo@foo.com', password: 'password')
        expect(user.email).to eql('foo@foo.com')
      end
    end
  end
end