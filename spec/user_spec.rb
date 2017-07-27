require 'spec_helper'

RSpec.describe TeachableClient::User do
  it 'exists' do
    expect(TeachableClient::User).not_to be nil
  end
  it 'registers a user' do
    VCR.use_cassette('user') do
      user = TeachableClient::User.register(email: 'foo@bar.com', password: 'password', password_confirmation: 'password')
      expect(user.email).to eql('foo@bar.com')
    end
  end
end