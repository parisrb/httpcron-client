require 'rest-client'
require 'net/http/digest_auth'
require 'json'

module HTTPCronClient

  class Connection

    attr_reader :limit

    # Create a new connection to a HTTPCron server
    # <tt>server_url</tt> the root server url
    # <tt>login</tt> the user login
    # <tt>password</tt> the user password
    # <tt>params</tt> other parameters in a hash
    # Available params:
    #  :limit max number of elements to return per request
    def initialize server_url, login, password, params = {}
      @server_url = server_url
      unless @server_url.end_with? '/'
        @server_url << '/'
      end
      @login = login
      @password = password
      @limit = params[:limit]

      authenticate
    end

    # Execute a request
    # <tt>type</tt> the http request type (:get, :post ...)
    # <tt>uri_fragment</tt> the uri part that is specific to this request
    # <tt>payload</tt> the request payload for post params
    def request type, uri_fragment, payload = {}
      url = "#{@server_url}api/#{uri_fragment}"
      uri = create_uri(url)
      auth = @digest_auth.auth_header uri, @header, type.to_s.upcase
      RestClient::Request.execute(:method => type, :url => url, :headers => {:authorization => auth}, :payload => payload)
    end

    # authenticate the user against the server
    def authenticate
      uri = create_uri("#{@server_url}api/authenticate")
      h = Net::HTTP.new uri.host, uri.port
      req = Net::HTTP::Get.new uri.request_uri
      res = h.request req
      @digest_auth = Net::HTTP::DigestAuth.new
      @header = res['www-authenticate']
      unless @header
        raise 'No [www-authenticate] header in the server\'s response'
      end
    end

    # Create an uri object from the url string and add the login / password
    def create_uri url
      uri = URI.parse url
      uri.user = @login
      uri.password = @password
      uri
    end

    def server_config
      JSON.parse(request :get, 'config')
    end

  end

end

