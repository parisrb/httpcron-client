require_relative 'helper'

describe 'execution API' do

  before do
    @connection = create_connection
  end

  it 'can get an execution by it\'s id' do
    stub_request(:get, 'http://localhost/api/executions/1').
        to_return(:status => 200, :body => EXECUTION_VALUE.to_json)
    stub_request(:get, 'http://localhost/api/tasks/1').
        to_return(:status => 200, :body => TASK_VALUE.to_json)

    execution = @connection.execution 1
    execution.class.must_equal HTTPCronClient::Execution

    execution.id.must_equal EXECUTION_VALUE['id']

    execution.task_id.must_equal EXECUTION_VALUE['task_id']
    execution.status.must_equal EXECUTION_VALUE['status']
    execution.started_at.must_equal DateTime.parse(EXECUTION_VALUE['started_at'])
    execution.duration.must_equal EXECUTION_VALUE['duration']
    execution.response.must_equal EXECUTION_VALUE['response']

    execution.task.class.must_equal HTTPCronClient::Task
    execution.task.id.must_equal 1
  end

  describe 'deletion' do

    it 'can delete an execution from the connection' do
      stub_request(:delete, 'http://localhost/api/executions/1').
          to_return(:status => 200, :body => '')
      @connection.delete_execution 1
    end

    it 'can delete an execution from the execution' do
      stub_request(:get, 'http://localhost/api/executions/1').
          to_return(:status => 200, :body => EXECUTION_VALUE.to_json)
      execution = @connection.execution 1

      stub_request(:delete, 'http://localhost/api/executions/1').
          to_return(:status => 200, :body => '')
      execution.delete
    end

  end

  describe 'list from current user' do

    it 'list all executions from current user' do
      stub_request(:get, 'http://localhost/api/executions/user/current?page=0').
          to_return(:status => 200, :body => create_list_response([EXECUTION_VALUE], 1))
      stub_request(:get, 'http://localhost/api/executions/user/current?page=1').
          to_return(:status => 200, :body => create_list_response([], 1))

      test_list_single_element @connection.executions_for_current_user do |t|
        t.class.must_equal HTTPCronClient::Execution
        t.id.must_equal 1
      end
    end

    it 'list failed executions from current user' do
      stub_request(:get, 'http://localhost/api/executions/user/current/failure?page=0').
          to_return(:status => 200, :body => create_list_response([EXECUTION_VALUE], 1))
      stub_request(:get, 'http://localhost/api/executions/user/current/failure?page=1').
          to_return(:status => 200, :body => create_list_response([], 1))

      test_list_single_element @connection.failed_executions_for_current_user do |t|
        t.class.must_equal HTTPCronClient::Execution
        t.id.must_equal 1
      end
    end

    it 'list successful executions from current user' do
      stub_request(:get, 'http://localhost/api/executions/user/current/success?page=0').
          to_return(:status => 200, :body => create_list_response([EXECUTION_VALUE], 1))
      stub_request(:get, 'http://localhost/api/executions/user/current/success?page=1').
          to_return(:status => 200, :body => create_list_response([], 1))

      test_list_single_element @connection.successful_executions_for_current_user do |t|
        t.class.must_equal HTTPCronClient::Execution
        t.id.must_equal 1
      end
    end

  end

  describe 'list executions for another user' do

    describe 'from the connection' do

      it 'list all executions for another user from the connection' do
        stub_request(:get, 'http://localhost/api/executions/user/1?page=0').
            to_return(:status => 200, :body => create_list_response([EXECUTION_VALUE], 1))
        stub_request(:get, 'http://localhost/api/executions/user/1?page=1').
            to_return(:status => 200, :body => create_list_response([], 1))

        test_list_single_element @connection.executions_for_user(1) do |t|
          t.class.must_equal HTTPCronClient::Execution
          t.id.must_equal EXECUTION_VALUE['id']
        end
      end

      it 'list failed executions for another user from the connection' do
        stub_request(:get, 'http://localhost/api/executions/user/1/failure?page=0').
            to_return(:status => 200, :body => create_list_response([EXECUTION_VALUE], 1))
        stub_request(:get, 'http://localhost/api/executions/user/1/failure?page=1').
            to_return(:status => 200, :body => create_list_response([], 1))

        test_list_single_element @connection.failed_executions_for_user(1) do |t|
          t.class.must_equal HTTPCronClient::Execution
          t.id.must_equal EXECUTION_VALUE['id']
        end
      end

      it 'list successful executions for another user from the connection' do
        stub_request(:get, 'http://localhost/api/executions/user/1/success?page=0').
            to_return(:status => 200, :body => create_list_response([EXECUTION_VALUE], 1))
        stub_request(:get, 'http://localhost/api/executions/user/1/success?page=1').
            to_return(:status => 200, :body => create_list_response([], 1))

        test_list_single_element @connection.successful_executions_for_user(1) do |t|
          t.class.must_equal HTTPCronClient::Execution
          t.id.must_equal EXECUTION_VALUE['id']
        end
      end

    end

    describe 'from the user' do

      it 'list all executions for another user from the user' do
        stub_request(:get, 'http://localhost/api/executions/user/1?page=0').
            to_return(:status => 200, :body => create_list_response([EXECUTION_VALUE], 1))
        stub_request(:get, 'http://localhost/api/executions/user/1?page=1').
            to_return(:status => 200, :body => create_list_response([], 1))

        test_list_single_element current_user.executions do |t|
          t.class.must_equal HTTPCronClient::Execution
          t.id.must_equal EXECUTION_VALUE['id']
        end
      end

      it 'list failed executions for another user from the user' do
        stub_request(:get, 'http://localhost/api/executions/user/1/failure?page=0').
            to_return(:status => 200, :body => create_list_response([EXECUTION_VALUE], 1))
        stub_request(:get, 'http://localhost/api/executions/user/1/failure?page=1').
            to_return(:status => 200, :body => create_list_response([], 1))

        test_list_single_element current_user.failed_executions do |t|
          t.class.must_equal HTTPCronClient::Execution
          t.id.must_equal EXECUTION_VALUE['id']
        end
      end

      it 'list successful executions for another user from the user' do
        stub_request(:get, 'http://localhost/api/executions/user/1/success?page=0').
            to_return(:status => 200, :body => create_list_response([EXECUTION_VALUE], 1))
        stub_request(:get, 'http://localhost/api/executions/user/1/success?page=1').
            to_return(:status => 200, :body => create_list_response([], 1))

        test_list_single_element current_user.successful_executions do |t|
          t.class.must_equal HTTPCronClient::Execution
          t.id.must_equal EXECUTION_VALUE['id']
        end
      end

    end

  end

  describe 'list executions for a task' do

    describe 'from the connection' do

      it 'list all executions for a task from the connection' do
        stub_request(:get, 'http://localhost/api/executions/task/1?page=0').
            to_return(:status => 200, :body => create_list_response([EXECUTION_VALUE], 1))
        stub_request(:get, 'http://localhost/api/executions/task/1?page=1').
            to_return(:status => 200, :body => create_list_response([], 1))

        test_list_single_element @connection.executions(1) do |t|
          t.class.must_equal HTTPCronClient::Execution
          t.id.must_equal EXECUTION_VALUE['id']
        end
      end

      it 'list failed executions for a task from the connection' do
        stub_request(:get, 'http://localhost/api/executions/task/1/failure?page=0').
            to_return(:status => 200, :body => create_list_response([EXECUTION_VALUE], 1))
        stub_request(:get, 'http://localhost/api/executions/task/1/failure?page=1').
            to_return(:status => 200, :body => create_list_response([], 1))

        test_list_single_element @connection.failed_executions(1) do |t|
          t.class.must_equal HTTPCronClient::Execution
          t.id.must_equal EXECUTION_VALUE['id']
        end
      end

      it 'list successful executions for a task from the connection' do
        stub_request(:get, 'http://localhost/api/executions/task/1/success?page=0').
            to_return(:status => 200, :body => create_list_response([EXECUTION_VALUE], 1))
        stub_request(:get, 'http://localhost/api/executions/task/1/success?page=1').
            to_return(:status => 200, :body => create_list_response([], 1))

        test_list_single_element @connection.successful_executions(1) do |t|
          t.class.must_equal HTTPCronClient::Execution
          t.id.must_equal EXECUTION_VALUE['id']
        end
      end
    end

    describe 'from the task' do

      it 'list all executions for a task from the task' do
        stub_request(:get, 'http://localhost/api/tasks/1').
            to_return(:status => 200, :body => TASK_VALUE.to_json)
        stub_request(:get, 'http://localhost/api/executions/task/1?page=0').
            to_return(:status => 200, :body => create_list_response([EXECUTION_VALUE], 1))
        stub_request(:get, 'http://localhost/api/executions/task/1?page=1').
            to_return(:status => 200, :body => create_list_response([], 1))

        test_list_single_element @connection.task(1).executions do |t|
          t.class.must_equal HTTPCronClient::Execution
          t.id.must_equal EXECUTION_VALUE['id']
        end
      end

      it 'list failed executions for a task from the task' do
        stub_request(:get, 'http://localhost/api/tasks/1').
            to_return(:status => 200, :body => TASK_VALUE.to_json)
        stub_request(:get, 'http://localhost/api/executions/task/1/failure?page=0').
            to_return(:status => 200, :body => create_list_response([EXECUTION_VALUE], 1))
        stub_request(:get, 'http://localhost/api/executions/task/1/failure?page=1').
            to_return(:status => 200, :body => create_list_response([], 1))

        test_list_single_element @connection.task(1).failed_executions do |t|
          t.class.must_equal HTTPCronClient::Execution
          t.id.must_equal EXECUTION_VALUE['id']
        end
      end

      it 'list successful execution for a task from the task' do
        stub_request(:get, 'http://localhost/api/tasks/1').
            to_return(:status => 200, :body => TASK_VALUE.to_json)
        stub_request(:get, 'http://localhost/api/executions/task/1/success?page=0').
            to_return(:status => 200, :body => create_list_response([EXECUTION_VALUE], 1))
        stub_request(:get, 'http://localhost/api/executions/task/1/success?page=1').
            to_return(:status => 200, :body => create_list_response([], 1))

        test_list_single_element @connection.task(1).successful_executions do |t|
          t.class.must_equal HTTPCronClient::Execution
          t.id.must_equal EXECUTION_VALUE['id']
        end
      end
    end

  end

end