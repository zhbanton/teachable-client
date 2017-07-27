# TeachableClient

Simple Ruby Wrapper for mock Teachable API (https://fast-bayou-75985.herokuapp.com/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'teachable_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install teachable_client

## Usage

```ruby
# Register a user
# returns TeachableClient::User
TeachableClient::User.register(email: 'foo@foo.com', password: 'password', password_confirmation: 'password')

# Authenticate a user (can skip above step and jump here if you already have an account)
# returns TeachableClient::User 
client = TeachableClient::User.authenticate(email: 'foo@foo.com', password: 'password')

# fetch current user data
# returns TeachableClient::User 
client.current_user

# create a new order
# returns TeachableClient::Order
client.create_order(total: 4.0, total_quantity: 4, special_instructions: 'do it now!')

# view current user's orders
# returns array of TeachableClient::Order objects
client.orders

# destroy an order
# returns true when successful
client.destroy_order(123)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
