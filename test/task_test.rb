require_relative 'helper'

describe 'task API' do

  before do
    @connection = create_connection
  end

  it 'can get a task by it\'s id' do
    stub_request(:get, 'http://localhost/api/tasks/1').
        to_return(:status => 200, :body => TASK_VALUE.to_json)
    stub_request(:get, 'http://localhost/api/users/1').
        to_return(:status => 200, :body => USER_VALUE.to_json)

    task = @connection.task 1
    task.class.must_equal HTTPCronClient::Task

    task.id.must_equal TASK_VALUE['id']

    task.name.must_equal TASK_VALUE['name']
    task.url.must_equal TASK_VALUE['url']
    task.next_execution.must_equal DateTime.parse(TASK_VALUE['next_execution'])
    task.cron.must_equal TASK_VALUE['cron']
    task.timeout.must_equal TASK_VALUE['timeout']
    task.timezone.must_equal TASK_VALUE['timezone']
    task.enabled.must_equal TASK_VALUE['enabled']

    task.created_at.must_equal DateTime.parse(TASK_VALUE['created_at'])
    task.updated_at.must_equal DateTime.parse(TASK_VALUE['updated_at'])

    task.user.class.must_equal HTTPCronClient::User
    task.user.id.must_equal 1
  end

  describe 'deletion' do

    it 'can delete a task from the connection' do
      stub_request(:delete, 'http://localhost/api/tasks/1').
          to_return(:status => 200, :body => '')
      @connection.delete_task 1
    end

    it 'can delete a task from the task' do
      stub_request(:get, 'http://localhost/api/tasks/1').
          to_return(:status => 200, :body => TASK_VALUE.to_json)
      task = @connection.task 1

      stub_request(:delete, 'http://localhost/api/tasks/1').
          to_return(:status => 200, :body => '')
      task.delete
    end

  end

  describe 'creation' do

    it 'can create a task from the connection' do
      stub_request(:post, 'http://localhost/api/tasks').
          with(:body => {'user_id' => '1', 'name' => 'task', 'cron' => '0 0 1 1 *', 'url' => 'http://example.com', 'mail_when_success' => 'false', 'mail_when_failure' => 'false'}).
          to_return(:status => 200, :body => TASK_VALUE.to_json)
      task = @connection.create_task 1, 'task', 'http://example.com', '0 0 1 1 *'
      task.class.must_equal HTTPCronClient::Task
      task.id.must_equal USER_VALUE['id']
    end

    it 'can create a task from the user' do
      user = current_user

      stub_request(:post, 'http://localhost/api/tasks').
          with(:body => {'user_id' => '1', 'name' => 'task', 'cron' => '0 0 1 1 *', 'url' => 'http://example.com', 'mail_when_success' => 'false', 'mail_when_failure' => 'false'}).
          to_return(:status => 200, :body => TASK_VALUE.to_json)
      task = user.create_task 'task', 'http://example.com', '0 0 1 1 *'
      task.class.must_equal HTTPCronClient::Task
      task.id.must_equal USER_VALUE['id']
    end

  end

  it 'can list tasks for current user' do
    stub_request(:get, 'http://localhost/api/tasks?page=0').
        to_return(:status => 200, :body => create_list_response([TASK_VALUE], 1))
    stub_request(:get, 'http://localhost/api/tasks?page=1').
        to_return(:status => 200, :body => create_list_response([], 1))

    test_list_single_element @connection.tasks do |t|
      t.class.must_equal HTTPCronClient::Task
      t.id.must_equal TASK_VALUE['id']
    end

  end

  describe 'list tasks for another user' do

    it 'can list tasks from the connection' do
      stub_request(:get, 'http://localhost/api/tasks/user/1?page=0').
          to_return(:status => 200, :body => create_list_response([TASK_VALUE], 1))
      stub_request(:get, 'http://localhost/api/tasks/user/1?page=1').
          to_return(:status => 200, :body => create_list_response([], 1))

      test_list_single_element @connection.tasks(1) do |t|
        t.class.must_equal HTTPCronClient::Task
        t.id.must_equal TASK_VALUE['id']
      end
    end

    it 'can list tasks from the user' do
      stub_request(:get, 'http://localhost/api/tasks/user/1?page=0').
          to_return(:status => 200, :body => create_list_response([TASK_VALUE], 1))
      stub_request(:get, 'http://localhost/api/tasks/user/1?page=1').
          to_return(:status => 200, :body => create_list_response([], 1))

      test_list_single_element current_user.tasks do |t|
        t.class.must_equal HTTPCronClient::Task
        t.id.must_equal TASK_VALUE['id']
      end

    end

    it 'can list tasks from the connection with order' do
      stub_request(:get, 'http://localhost/api/tasks/user/1?order=name.asc&page=0').
          to_return(:status => 200, :body => create_list_response([TASK_VALUE], 1))
      stub_request(:get, 'http://localhost/api/tasks/user/1?order=name.asc&page=1').
          to_return(:status => 200, :body => create_list_response([], 1))

      test_list_single_element @connection.tasks(1, 'name.asc') do |t|
        t.class.must_equal HTTPCronClient::Task
        t.id.must_equal TASK_VALUE['id']
      end
    end

    it 'can list tasks from the user with order' do
      stub_request(:get, 'http://localhost/api/tasks/user/1?order=name.asc&page=0').
          to_return(:status => 200, :body => create_list_response([TASK_VALUE], 1))
      stub_request(:get, 'http://localhost/api/tasks/user/1?order=name.asc&page=1').
          to_return(:status => 200, :body => create_list_response([], 1))

      test_list_single_element current_user.tasks('name.asc') do |t|
        t.class.must_equal HTTPCronClient::Task
        t.id.must_equal TASK_VALUE['id']
      end

    end

  end

end
