require 'spec_helper'

RSpec.describe TeachableClient::User do
  it 'exists' do
    expect(TeachableClient::User).not_to be nil
  end
  describe 'class methods' do
    describe '.register' do
      describe 'when registration is successful' do
        it 'registers a user' do
          VCR.use_cassette('register') do
            user = TeachableClient::User.register(email: 'foo@foo.com', password: 'password', password_confirmation: 'password')
            expect(user.email).to eql('foo@foo.com')
          end
        end
      end
      describe 'when registration is successful' do
        it 'raises 422' do
          VCR.use_cassette('register_email_taken') do
            expect { TeachableClient::User.register(email: 'foo@foo.com', password: 'password', password_confirmation: 'password') }.to raise_exception(TeachableClient::Error::UnprocessableEntity)
          end
        end
      end
      describe 'when password doesn\'t match password confirmation' do
        it 'raises 422' do
          VCR.use_cassette('register_password_mismatch') do
            expect { TeachableClient::User.register(email: 'foo@foo.com', password: 'password', password_confirmation: 'blah') }.to raise_exception(TeachableClient::Error::UnprocessableEntity)
          end
        end
      end
    end
    describe '.authenticate' do
      describe 'when authentication is successful' do
        it 'authenticates a user' do
          VCR.use_cassette('authenticate') do
            user = TeachableClient::User.authenticate(email: 'foo@foo.com', password: 'password')
            expect(user.email).to eql('foo@foo.com')
          end
        end
      end
      describe 'when email is not registered' do
        it 'raises 401' do
          VCR.use_cassette('authenticate_no_email') do
            expect { TeachableClient::User.authenticate(email: 'foo@blahblah.com', password: 'password') }.to raise_exception(TeachableClient::Error::Unauthorized)
          end
        end
      end
      describe 'when password is invalid' do
        it 'raises 401' do
          VCR.use_cassette('authenticate_wrong_password') do
            expect { TeachableClient::User.authenticate(email: 'foo@foo.com', password: 'passwordddd') }.to raise_exception(TeachableClient::Error::Unauthorized)
          end
        end
      end
    end
  end
  describe 'instance methods' do
    before do
      VCR.use_cassette('authenticate') do
        @client = TeachableClient::User.authenticate(email: 'foo@foo.com', password: 'password')
      end
      @unauthorized_client = TeachableClient::User.new({'email' => 'foo@foo.com', 'tokens' => '123' })
    end
    describe '#current_user' do
      describe 'when client is authorized' do
        it 'should return current user' do
          VCR.use_cassette('current_user') do
            user = @client.current_user
            expect(user.email).to eql('foo@foo.com')
          end
        end
      end
      describe 'when client is unauthorized' do
        it 'should raise 401' do
          VCR.use_cassette('current_user_unauthorized') do
            expect { @unauthorized_client.current_user }.to raise_exception(TeachableClient::Error::Unauthorized)
          end
        end
      end
    end
    describe '#create_order' do
      describe 'when client is authorized' do
        describe 'when order params are valid' do
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
        describe 'when required order param is missing' do
          it 'should raise 422' do
            VCR.use_cassette('create_order_invalid') do
              expect { @client.create_order(total: nil, total_quantity: 4, special_instructions: 'do it now!') }.to raise_exception(TeachableClient::Error::UnprocessableEntity)
            end
          end
        end
      end
      describe 'when client is unauthorized' do
        it 'should raise 401' do
          VCR.use_cassette('create_order_unauthorized') do
            expect { @unauthorized_client.create_order(total: 4.0, total_quantity: 4, special_instructions: 'do it now!') }.to raise_exception(TeachableClient::Error::Unauthorized)
          end
        end
      end
    end
    describe '#orders' do
      describe 'when client is authorized' do
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
      describe 'when client is unauthorized' do
        it 'should raise 401' do
          VCR.use_cassette('orders_unauthorized') do
            expect { @unauthorized_client.orders }.to raise_exception(TeachableClient::Error::Unauthorized)
          end
        end
      end
    end
    describe '#destroy_order' do
      describe 'when client is authorized' do
        describe 'when order belongs to current user' do
          it 'should destroy given order' do
            VCR.use_cassette('destroy_order') do
              expect(@client.destroy_order(480)).to be(true)
            end
          end
        end
        describe 'when order does not exist' do
          it 'should raise 404' do
            VCR.use_cassette('destroy_order_invalid') do
              expect { @client.destroy_order(4800000000) }.to raise_exception(TeachableClient::Error::NotFound)
            end
          end
        end
        describe 'when order does not belong to current user' do
          it 'should raise 401' do
            VCR.use_cassette('destroy_order_wrong_user') do
              expect { @client.destroy_order(481) }.to raise_exception(TeachableClient::Error::Unauthorized)
            end
          end
        end
      end
      describe 'when client is unauthorized' do
        it 'should raise 401' do
          VCR.use_cassette('destroy_order_unauthorized') do
            expect { @unauthorized_client.destroy_order(480) }.to raise_exception(TeachableClient::Error::Unauthorized)
          end
        end
      end
    end
  end
end