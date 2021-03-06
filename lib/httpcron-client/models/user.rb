module HTTPCronClient

  class User < HTTPCronClientModel

    attr_accessor :username, :timezone, :admin, :email_address

    attr_reader :id, :created_at, :updated_at

    attr_writer :password

    def initialize connection, hash
      super connection
      from_hash hash
    end

    # Create a task and return it
    def create_task name, url, cron, enabled = nil, timeout = nil, mail_when_success = false, mail_when_failure = false, timezone = nil
      connection.create_task(id, name, url, cron, enabled, timeout, mail_when_success, mail_when_failure, timezone)
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
      connection.failed_executions_for_user id, order
    end

    # List the executions for this user
    # <tt>order</tt> can specify the order
    def executions order = nil
      connection.executions_for_user id, order
    end

    # Save the user
    def save
      params = {:id => id, :username => username, :timezone => timezone, :admin => admin, :email_address => email_address}
      if @password
        params[:password] = @password
      end
      from_hash(JSON.parse(connection.request :put, "users/#{id}", params))
      self
    end

    # List the successful executions for this user
    # <tt>order</tt> can specify the order
    def successful_executions order = nil
      connection.successful_executions_for_user id, order
    end

    # List the tasks for this user
    # <tt>order</tt> can specify the order
    def tasks order = nil
      connection.tasks(id, order)
    end

    def to_s
      "User id: [#{id}], username: [#{username}], email_address: [#{email_address}], admin: [#{admin}] timezone: [#{timezone}], created_at: [#{created_at}], updated_at: [#{updated_at}]"
    end

    private

    # Fill the fields from a hash
    def from_hash hash
      @id= hash['id']

      @admin= hash['admin']
      @username= hash['username']
      @timezone= hash['timezone']
      @email_address= hash['email_address']

      @password = nil

      @created_at= DateTime.parse(hash['created_at'])
      @updated_at= DateTime.parse(hash['updated_at'])
    end

  end
end