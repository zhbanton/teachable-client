require 'faraday'
require 'json'

module TeachableClient
  class User

    BASE_URL = 'https://fast-bayou-75985.herokuapp.com'

    attr_reader :id, :name, :nickname, :image, :email, :tokens, :created_at, :updated_at

    def initialize(attributes)
      @id = attributes['id'].to_i
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

    def self.authenticate(email:, password:)
      response = Faraday.post("#{BASE_URL}/users/sign_in.json", {
        user: {
          email: email,
          password: password
        }
      })
      attributes = JSON.parse(response.body)
      new(attributes)
    end

    def current_user
      response = Faraday.get("#{BASE_URL}/api/users/current_user/edit.json?#{authentication_params}")
      attributes = JSON.parse(response.body)
      self.class.new(attributes)
    end

    def create_order(total:, total_quantity:, special_instructions:)
      response = Faraday.post("#{BASE_URL}/api/orders.json?#{authentication_params}", {
        order: {
          total: total,
          total_quantity: total_quantity,
          email: @email,
          special_instructions: special_instructions
        }
      })
      attributes = JSON.parse(response.body)
      TeachableClient::Order.new(attributes)
    end

    def orders
      response = Faraday.get("#{BASE_URL}/api/orders.json?#{authentication_params}")
      raw_orders = JSON.parse(response.body)
      raw_orders.map do |attributes|
        TeachableClient::Order.new(attributes)
      end
    end

    def destroy_order(order_id)
      response = Faraday.delete("#{BASE_URL}/api/orders/#{order_id}.json?#{authentication_params}")
      response.status == 204
    end

    private

      def authentication_params
        "user_email=#{@email}&user_token=#{@tokens}"
      end

  end
end