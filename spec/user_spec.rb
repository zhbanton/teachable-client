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
    describe '#create_order' do
      it 'should return new order' do
        VCR.use_cassette('create_order') do
          order = @client.create_order(total: 4.0, total_quantity: 4, special_instructions: 'do it now!')
          expect(order.class).to eql(TeachableClient::Order)
          expect(order.total).to eql(4.0)
          expect(order.total_quantity).to eql(4)
          expect(order.special_instructions).to eql('do it now!')
        end
      end
    end
    describe '#orders' do
      it 'should return list of users orders' do
        VCR.use_cassette('orders') do
          order = @client.orders.first
          expect(order.class).to eql(TeachableClient::Order)
          expect(order.total).to eql(4.0)
          expect(order.total_quantity).to eql(4)
          expect(order.special_instructions).to eql('do it now!')
        end
      end
    end
    describe '#destroy_order' do
      it 'should destroy given order' do
        VCR.use_cassette('destroy_order') do
          expect(@client.destroy_order(480)).to be(true)
        end
      end
    end
  end
end