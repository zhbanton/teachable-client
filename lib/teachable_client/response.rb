module TeachableClient
  class Response

    attr_reader :body, :status

    def initialize(response)
      # body can be empty string, in which case JSON.parse will return error
      @body = response.body.empty? ? response.body : JSON.parse(response.body)
      @status = response.status
      error = Error::ERRORS[response.status]
      unless error.nil?
        raise error.new(body)
      end
    end

  end
end