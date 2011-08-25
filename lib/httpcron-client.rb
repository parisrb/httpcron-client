require "httpcron-client/version"

require 'rest-client'
require 'net/http/digest_auth'
require 'json'

module HTTPCronClient

  class Connection

    def initialize server, login, password
      @server = server
      unless @server.end_with? '/'
        @server << '/'
      end
      @login = login
      @password = password
      authenticate
    end

    # Execute a request
    # type:: the http request type (get, post ...)
    # uri_fragment:: the uri part that is specific to this request
    # payload:: the request payload
    def request type, uri_fragment, payload = {}
      url = "#{@server}api/#{uri_fragment}"
      uri = create_uri(url)
      auth = @digest_auth.auth_header uri, @header, type.to_s.upcase
      RestClient::Request.new(:method => type, :url => url, :headers => {:authorization => auth}, :payload => payload).execute
    end

    # Get the current User
    def current_user
      User.new(JSON.parse(request :get, 'users/current'), self)
    end

    # Get a User from its id
    def user id
      User.new(JSON.parse(request :get, "users/#{id}"), self)
    end

    # Create a User and return it
    def create_user username, password, admin = false, timezone = nil
      params = {:username => username, :password => password, :admin => admin}
      if timezone
        params[:timezone] = timezone
      end
      User.new(JSON.parse(request :post, 'users', params), self)
    end

    private

    # authenticate the user against the server
    def authenticate
      uri = create_uri("#{@server}api/authenticate")
      h = Net::HTTP.new uri.host, uri.port
      req = Net::HTTP::Get.new uri.request_uri
      res = h.request req
      @digest_auth = Net::HTTP::DigestAuth.new
      @header = res['www-authenticate']
    end

    # Create an uri object from the url string and add the login / password
    def create_uri url
      uri = URI.parse url
      uri.user = @login
      uri.password = @password
      uri
    end

  end

  # An object handled by HTTPCronClient
  class HTTPCronClientObject

    attr_reader :connection

    def initialize connection
      @connection = connection
    end

  end

  class User < HTTPCronClientObject

    attr_accessor :username, :timezone, :admin

    attr_reader :created_at, :updated_at, :id

    attr_writer :password

    def initialize hash, connection
      super connection
      from_hash hash
    end

    # Save the user
    def save
      params = {:id => id, :username => username, :timezone => timezone, :admin => admin}
      if @password
        params[:password] = @password
      end
      from_hash(JSON.parse(connection.request :put, "users/#{id}", params))
    end

    # Delete the user
    def delete
      connection.request :delete, "users/#{id}", params
    end

    def to_s
      "User id: [#{id}], username: [#{username}], admin: [#{admin}] timezone: [#{timezone}], created_at: [#{created_at}], updated_at: [#{updated_at}]"
    end

    private

    def from_hash hash
      @id= hash['id']
      @admin= hash['admin']
      @username= hash['username']
      @timezone= hash['timezone']
      @created_at= DateTime.parse(hash['created_at'])
      @updated_at= DateTime.parse(hash['updated_at'])
      @password = nil
    end

  end

end
