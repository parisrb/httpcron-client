require 'test/unit'
require 'minitest/spec'

require 'webmock/minitest'
require_relative '../lib/httpcron-client'

def create_connection
  stub_request(:get, "http://localhost/api/authenticate").
      to_return(:status => 200, :body => "", :headers => {'www-authenticate' => "Digest realm=\"CromagnonApi\", nonce=\"MTMxNDkwMDA3NCBiZTRhNzAxNmUzNmM1NTAyYzdkNTA2MGFhZDJhYmMyNg==\", opaque=\"33d5a5992d35f7d8793fb31d5a619b34\", qop=\"auth\""})
  HTTPCronClient::Connection.new 'http://localhost', 'httpcronadmin', 'httpcronadmin'
end

USER_VALUE = {"created_at"=>"2011-08-29T20:55:51+00:00", "updated_at"=>"2011-08-29T20:55:51+00:00", "admin"=>true, "username"=>"httpcronadmin", "timezone"=>"UTC", "id"=>1}
