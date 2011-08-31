module HTTPCronClient

  class User < HTTPCronClientModel

    attr_accessor :username, :timezone, :admin

    attr_reader :id, :created_at, :updated_at

    attr_writer :password

    def initialize connection, hash
      super connection
      from_hash hash
    end

    # Create a task and return it
    def create_task name, url, cron, enabled = nil, timeout = nil, timezone = nil
      connection.create_task(id, name, url, cron, enabled, timeout, timezone)
    end

    # Delete the user
    # <tt>order</tt> can specify the order
    def delete
      connection.delete_user id
      nil
    end

    # List the failed executions for this user
    # <tt>order</tt> can specify the order
    def failed_executions order = nil
      connections.failed_executions_for_user id, order
    end

    # List the executions for this user
    # <tt>order</tt> can specify the order
    def executions order = nil
      connections.executions_for_user id, order
    end

    # Save the user
    def save
      params = {:id => id, :username => username, :timezone => timezone, :admin => admin}
      if @password
        params[:password] = @password
      end
      from_hash(JSON.parse(connection.request :put, "users/#{id}", params))
      self
    end

    # List the successful executions for this user
    # <tt>order</tt> can specify the order
    def successful_executions order = nil
      connections.successful_executions_for_user id, order
    end

    # List the tasks for this user
    # <tt>order</tt> can specify the order
    def tasks order = nil
      connection.tasks(id, order)
    end

    def to_s
      "User id: [#{id}], username: [#{username}], admin: [#{admin}] timezone: [#{timezone}], created_at: [#{created_at}], updated_at: [#{updated_at}]"
    end

    private

    # Fill the fields from a hash
    def from_hash hash
      @id= hash['id']

      @admin= hash['admin']
      @username= hash['username']
      @timezone= hash['timezone']

      @password = nil

      @created_at= DateTime.parse(hash['created_at'])
      @updated_at= DateTime.parse(hash['updated_at'])
    end

  end
end