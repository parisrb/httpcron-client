module HTTPCronClient

  # An object handled by HTTPCronClient
  class HTTPCronClientModel

    attr_reader :connection

    def initialize connection
      @connection = connection
    end

  end

end