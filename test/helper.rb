require 'test/unit'
require 'minitest/spec'

require 'webmock/minitest'
require_relative '../lib/httpcron-client'

USER_VALUE = {
    "created_at" => "2011-08-29T20:55:51+00:00",
    "updated_at" => "2011-08-29T20:55:51+00:00",
    "admin" => true,
    "username" => "httpcronadmin",
    "timezone" => "UTC",
    "id" => 1}

TASK_VALUE = {"name" => "task",
              "created_at" => "2011-09-01T18:21:50+00:00",
              "updated_at" => "2011-09-01T18:21:50+00:00",
              "next_execution" => "2012-01-01T00:00:00+00:00",
              "cron" => "0 0 1 1 *",
              "timeout" => 60,
              "url" => "http://example.com",
              "timezone" => "UTC",
              "enabled" => true,
              "id" => 1,
              "user_id" => 1}

def create_connection
  stub_request(:get, "http://localhost/api/authenticate").
      to_return(:status => 200, :body => "", :headers => {'www-authenticate' => "Digest realm=\"CromagnonApi\", nonce=\"MTMxNDkwMDA3NCBiZTRhNzAxNmUzNmM1NTAyYzdkNTA2MGFhZDJhYmMyNg==\", opaque=\"33d5a5992d35f7d8793fb31d5a619b34\", qop=\"auth\""})
  HTTPCronClient::Connection.new 'http://localhost', 'httpcronadmin', 'httpcronadmin'
end

def current_user
  stub_request(:get, 'http://localhost/api/users/current').
      to_return(:status => 200, :body => USER_VALUE.to_json)
  @connection.current_user
end
