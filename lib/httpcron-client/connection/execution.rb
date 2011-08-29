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
      PaginatedEnum.new self, "executions/task/#{task_id}", Task, order
    end

  end

end
