require_relative 'httpcron-client-object'

module HTTPCronClient

  # An enumeration relying on HTTPCron pagination
  class PaginatedEnum < HTTPCronClientObject

    include Enumerable

    def initialize connection, path, object_class, order = nil
      super connection
      @path = path
      @object_class = object_class
      @params = {}
      if order
        @params[:order] = order
      end
    end

    def each &block
      current_page = 0
      while (records = JSON.parse(connection.request(:get, "#{@path}?page=#{current_page}&limit=#{connection.limit}", {}))['records']).length > 0
        records.each do |r|
          block.call(@object_class.new(connection, r))
        end
        current_page += 1
      end
    end

  end

end
