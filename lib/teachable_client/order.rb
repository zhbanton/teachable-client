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

  end
end
