require_relative 'helper'

describe 'user API' do

  before do
    @connection = create_connection
  end

  it 'can get the default user' do
    stub_request(:get, "http://localhost/api/users/current").
        to_return(:status => 200, :body => USER_VALUE.to_json)

    user = @connection.current_user
    user.class.must_equal HTTPCronClient::User

    user.id.must_equal USER_VALUE['id']

    user.admin.must_equal USER_VALUE['admin']
    user.username.must_equal USER_VALUE['username']
    user.timezone.must_equal USER_VALUE['timezone']

    user.created_at.must_equal DateTime.parse(USER_VALUE['created_at'])
    user.updated_at.must_equal DateTime.parse(USER_VALUE['updated_at'])
  end

  it 'can get a user' do
    stub_request(:get, "http://localhost/api/users/1").
        to_return(:status => 200, :body => USER_VALUE.to_json)

    user = @connection.user 1
    user.class.must_equal HTTPCronClient::User
    user.id.must_equal USER_VALUE['id']
  end

  it 'can delete a user from the connection' do
    stub_request(:delete, "http://localhost/api/users/1").
        to_return(:status => 200, :body => "")
    @connection.delete_user 1
  end

  it 'can delete a user from the user' do
    stub_request(:get, "http://localhost/api/users/1").
        to_return(:status => 200, :body => USER_VALUE.to_json)
    user = @connection.user 1

    stub_request(:delete, "http://localhost/api/users/1").
        to_return(:status => 200, :body => "")
    user.delete
  end

  it 'can create a user' do
    stub_request(:post, "http://localhost/api/users").
        with(:body => {"username"=>"foo", "password"=>"bar", "admin"=>"false"}).
        to_return(:status => 200, :body => USER_VALUE.to_json)
    user = @connection.create_user 'foo', 'bar'
    user.class.must_equal HTTPCronClient::User
    user.id.must_equal USER_VALUE['id']
  end

end
