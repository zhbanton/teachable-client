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
       response = Response.new(Faraday.post("#{BASE_URL}/users.json", {
        user: {
          email: email,
          password: password,
          password_confirmation: password_confirmation
        }
      }))
      new(response.body)
    end

    def self.authenticate(email:, password:)
      response = Response.new(Faraday.post("#{BASE_URL}/users/sign_in.json", {
        user: {
          email: email,
          password: password
        }
      }))
      new(response.body)
    end

    def current_user
      response = Response.new(Faraday.get("#{BASE_URL}/api/users/current_user/edit.json?#{authentication_params}"))
      self.class.new(response.body)
    end

    def create_order(total:, total_quantity:, special_instructions:)
      response = Response.new(Faraday.post("#{BASE_URL}/api/orders.json?#{authentication_params}", {
        order: {
          total: total,
          total_quantity: total_quantity,
          email: @email,
          special_instructions: special_instructions
        }
      }))
      Order.new(response.body)
    end

    def orders
      response = Response.new(Faraday.get("#{BASE_URL}/api/orders.json?#{authentication_params}"))
      response.body.map do |attributes|
        Order.new(attributes)
      end
    end

    def destroy_order(order_id)
      response = Response.new(Faraday.delete("#{BASE_URL}/api/orders/#{order_id}.json?#{authentication_params}"))
      response.status == 204
    end

    private

      def authentication_params
        "user_email=#{@email}&user_token=#{@tokens}"
      end

  end
end