module TeachableClient
  module Error

    class Unauthorized < StandardError
    end

    class NotFound < StandardError
    end

    class UnprocessableEntity < StandardError
    end

    ERRORS = {
      401 => Unauthorized,
      404 => NotFound,
      422 => UnprocessableEntity
    }.freeze

  end
end