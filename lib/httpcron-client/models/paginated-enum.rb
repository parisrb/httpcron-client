require 'cgi'

module HTTPCronClient

  # An enumeration relying on HTTPCron pagination
  class PaginatedEnum < HTTPCronClientModel

    include Enumerable

    def initialize connection, path, object_class, order = nil
      super connection
      @path = path
      @object_class = object_class
      @params = {}

      if order
        @params[:order] = order
      end
      if connection.limit
        @params[:limit] = connection.limit
      end

    end

    def each &block
      current_page = 0
      while (records = JSON.parse(connection.request(:get, complete_path(current_page), {}))['records']).length > 0
        records.each do |r|
          block.call(@object_class.new(connection, r))
        end
        current_page += 1
      end
    end

    def complete_path current_page
      url = "#{@path}?page=#{current_page}"
      if @params.empty?
        url
      else
        query_string = @params.collect { |k, v| "#{k.to_s}=#{CGI::escape(v.to_s)}" }.join('&')
        "#{url}&#{query_string}"
      end

    end

  end

end
