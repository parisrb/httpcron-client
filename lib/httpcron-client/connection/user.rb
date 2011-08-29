module HTTPCronClient

  class Connection

    # Create a user
    def create_user username, password, admin = false, timezone = nil
      params = {:username => username, :password => password, :admin => admin}
      if timezone
        params[:timezone] = timezone
      end
      User.new(self, JSON.parse(request :post, 'users', params))
    end

    # The current user
    def current_user
      User.new(self, JSON.parse(request :get, 'users/current'))
    end

    # Delete a user
    def delete_user id
      request :delete, "users/#{id}"
      nil
    end

    # Get a user, need admin rights if not yourself
    def user user_id
      User.new(self, JSON.parse(request :get, "users/#{user_id}"))
    end

    # List the users, need admin rights
    # <tt>order</tt> can specify the order, default to id.desc
    def users order = nil
      PaginatedEnum.new self, 'users/', User, order
    end

  end
end

