require 'faraday'
require 'json'

module TeachableClient
  class Order

    attr_reader :id, :number, :total, :total_quantity, :email, :special_instructions, :created_at, :updated_at

    def initialize(attributes)
      @id = attributes['id'].to_i
      @number = attributes['number']
      @total = attributes['total'].to_f
      @total_quantity = attributes['total_quantity'].to_i
      @email = attributes['email']
      @special_instructions = attributes['special_instructions']
      @created_at = attributes['created_at']
      @updated_at = attributes['updated_at']
    end

    # def self.get
    #   Faraday.get("#{BASE_URL}/api/orders.json?user_email=foo@example.com&user_token=ivrRauSaqs8BKsTtyUxe")
    # end

    # def self.create(total:, total_quantity:, email:, special_instructions:)
    #   Faraday.post("#{BASE_URL}/api/orders.json?user_email=foo@example.com&user_token=ivrRauSaqs8BKsTtyUxe", {
    #     order: {
    #       number: number,
    #       total: total,
    #       total_quantity: total_quantity,
    #       email: email,
    #       special_instructions: special_instructions
    #     }
    #   })
    # end

    # def self.destroy(order_id)
    #   Faraday.delete("#{BASE_URL}/api/orders/#{order_id}.json?user_email=foo@example.com&user_token=ivrRauSaqs8BKsTtyUxe")
    # end

  end
end

# TeachableClient::Order.create(number: 3, total: 4.0, total_quantity: 4, email: 'bar@example.com', special_instructions: 'do it now!')