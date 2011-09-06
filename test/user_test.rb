require_relative 'helper'

describe 'user API' do

  before do
    @connection = create_connection
  end

  it 'can get the default user' do
    stub_request(:get, 'http://localhost/api/users/current').
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
    stub_request(:get, 'http://localhost/api/users/1').
        to_return(:status => 200, :body => USER_VALUE.to_json)

    user = @connection.user 1
    user.class.must_equal HTTPCronClient::User
    user.id.must_equal USER_VALUE['id']
  end

  describe 'deletion' do

    it 'can delete a user from the connection' do
      stub_request(:delete, 'http://localhost/api/users/1').
          to_return(:status => 200, :body => '')
      @connection.delete_user 1
    end

    it 'can delete a user from the user' do
      stub_request(:get, 'http://localhost/api/users/1').
          to_return(:status => 200, :body => USER_VALUE.to_json)
      user = @connection.user 1

      stub_request(:delete, 'http://localhost/api/users/1').
          to_return(:status => 200, :body => '')
      user.delete
    end

  end

  it 'can create a user' do
    stub_request(:post, 'http://localhost/api/users').
        with(:body => {'username' => 'foo', 'password' => 'bar', 'admin' => 'false'}).
        to_return(:status => 200, :body => USER_VALUE.to_json)
    user = @connection.create_user 'foo', 'bar'
    user.class.must_equal HTTPCronClient::User
    user.id.must_equal USER_VALUE['id']
  end

  it 'can update a user' do
    stub_request(:get, 'http://localhost/api/users/1').
        to_return(:status => 200, :body => USER_VALUE.to_json)

    user = @connection.user 1
    user.username = 'foo'
    user.password = 'bar'

    result = USER_VALUE.clone
    result['username'] = 'blarg'
    stub_request(:put, 'http://localhost/api/users/1').
        with(:body => {'id' => '1', 'username' => 'foo', 'timezone' => 'UTC', 'admin' => 'true', 'password' => 'bar'}).
        to_return(:status => 200, :body => result.to_json)
    user.save
    user.username.must_equal 'blarg'
  end

  it 'can lists user' do
    stub_request(:get, 'http://localhost/api/users/?page=0').
        to_return(:status => 200, :body => create_list_response([USER_VALUE], 1))
    stub_request(:get, 'http://localhost/api/users/?page=1').
        to_return(:status => 200, :body => create_list_response([], 1))

    test_list_single_element @connection.users do |u|
      u.class.must_equal HTTPCronClient::User
      u.id.must_equal USER_VALUE['id']
    end
  end

  it 'can lists user with order' do
    stub_request(:get, 'http://localhost/api/users/?order=username.desc&page=0').
        to_return(:status => 200, :body => create_list_response([USER_VALUE], 1))
    stub_request(:get, 'http://localhost/api/users/?order=username.desc&page=1').
        to_return(:status => 200, :body => create_list_response([], 1))

    test_list_single_element @connection.users('username.desc') do |u|
      u.class.must_equal HTTPCronClient::User
      u.id.must_equal USER_VALUE['id']
    end
  end

end
