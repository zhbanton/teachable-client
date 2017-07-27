require 'faraday'
require 'json'

module TeachableClient
  class User

    attr_reader :id, :name, :nickname, :image, :email, :tokens, :created_at, :updated_at

    def initialize(attributes)
      @id = attributes['id']
      @name = attributes['name']
      @nickname = attributes['nickname']
      @image = attributes['image']
      @email = attributes['email']
      @tokens = attributes['tokens']
      @created_at = attributes['created_at']
      @updated_at = attributes['updated_at']
    end

    def self.register(email:, password:, password_confirmation:)
      response = Faraday.post("#{BASE_URL}/users.json", {
        user: {
          email: email,
          password: password,
          password_confirmation: password_confirmation
        }
      })
      attributes = JSON.parse(response.body)
      new(attributes)
    end

  end
end