module HTTPCronClient

  class Connection

    # Create a task
    def create_task user_id, name, url, cron, enabled = nil, timeout = nil, timezone = nil
      params = {:user_id => user_id, :name=> name, :url => url, :cron => cron}
      if timezone
        params[:timezone] = timezone
      end
      if enabled
        params[:enabled] = enabled
      end
      if timeout
        params[:timeout] = timeout
      end
      Task.new(self, JSON.parse(request :post, 'tasks', params))
    end

    # Delete a task, need admin rights if not one you own
    def delete_task id
      request :delete, "tasks/#{id}"
      nil
    end

    # Get a task, need admin rights if not one you own
    def task id
      Task.new(self, JSON.parse(request :get, "tasks/#{id}"))
    end

    # List the tasks for a user, need admin rights if not yourself
    # <tt>user_id/<id> the user id, nil mean current user
    # <tt>order</tt> can specify the order, default to id.desc
    def tasks user_id = nil, order = nil
      if user_id
        PaginatedEnum.new self, 'tasks', Task, order
      else
        PaginatedEnum.new self, "tasks/user/#{user_id}", Task, order
      end
    end

  end

end

