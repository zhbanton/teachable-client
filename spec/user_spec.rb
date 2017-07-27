require 'spec_helper'

RSpec.describe TeachableClient::User do
  it 'exists' do
    expect(TeachableClient::User).not_to be nil
  end
  describe 'class methods' do
    describe '.register' do
      it 'registers a user' do
        VCR.use_cassette('register') do
          user = TeachableClient::User.register(email: 'foo@foo.com', password: 'password', password_confirmation: 'password')
          expect(user.email).to eql('foo@foo.com')
        end
      end
    end
    describe '.authenticate' do
      it 'authenticates a user' do
        VCR.use_cassette('authenticate') do
          user = TeachableClient::User.authenticate(email: 'foo@foo.com', password: 'password')
          expect(user.email).to eql('foo@foo.com')
        end
      end
    end
  end
  describe 'instance methods' do
    before do
      VCR.use_cassette('authenticate') do
        @client = TeachableClient::User.authenticate(email: 'foo@foo.com', password: 'password')
      end
    end
    describe '#current_user' do
      it 'should return current user' do
        VCR.use_cassette('current_user') do
          user = @client.current_user
          expect(user.email).to eql('foo@foo.com')
        end
      end
    end
  end
end