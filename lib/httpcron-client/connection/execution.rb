module HTTPCronClient

  class Connection

    # Delete an execution, need admin rights if not one you own
    def delete_execution id
      request :delete, "executions/#{id}"
      nil
    end

    # Get an execution, need admin rights if not one you own
    def execution id
      Execution.new(self, JSON.parse(request :get, "executions/#{id}"))
    end

    # List the executions for a task, need admin rights if not one you own
    # <tt>task_id/<id> the task id
    # <tt>order</tt> can specify the order, default to id.desc
    def executions task_id, order = nil
      execution_enum "executions/task/#{task_id}", order
    end

    # List the successful executions for a task, need admin rights if not one you own
    # <tt>task_id/<id> the task id
    # <tt>order</tt> can specify the order, default to id.desc
    def successful_executions task_id, order = nil
      execution_enum "executions/task/#{task_id}/success", order
    end

    # List the failed executions for a user, need admin rights if not one you own
    # <tt>task_id/<id> the task id
    # <tt>order</tt> can specify the order, default to id.desc
    def failed_executions task_id, order = nil
      execution_enum "executions/task/#{task_id}/failure", order
    end

    # List the executions for the current
    # <tt>order</tt> can specify the order, default to id.desc
    def executions_for_current_user order = nil
      execution_enum 'executions/user/current', order
    end

    # List the successful executions for the current user
    # <tt>order</tt> can specify the order, default to id.desc
    def successful_executions_for_current_user order = nil
      execution_enum 'executions/user/current/success', order
    end

    # List the failed executions for the current user
    # <tt>order</tt> can specify the order, default to id.desc
    def failed_executions_for_current_user order = nil
      execution_enum 'executions/user/current/failure', order
    end

    # List the executions for a user, need admin rights if not yourself
    # <tt>user_id/<id> the user id
    # <tt>order</tt> can specify the order, default to id.desc
    def executions_for_user user_id, order = nil
      execution_enum "executions/user/#{user_id}", order
    end

    # List the successful executions for a user, need admin rights if not yourself
    # <tt>user_id/<id> the user id
    # <tt>order</tt> can specify the order, default to id.desc
    def successful_executions_for_user user_id, order = nil
      execution_enum "executions/user/#{user_id}/success", order
    end

    # List the failed executions for a user, need admin rights if not yourself
    # <tt>user_id/<id> the user id
    # <tt>order</tt> can specify the order, default to id.desc
    def failed_executions_for_user user_id, order = nil
      execution_enum "executions/user/#{user_id}/failure", order
    end

    private

    def execution_enum path, order
      PaginatedEnum.new self, path, Execution, order
    end

  end

end
