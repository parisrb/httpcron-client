module HTTPCronClient

  class Task < HTTPCronClientModel

    attr_accessor :name, :url, :timeout, :enabled, :cron, :timezone, :mail_when_success, :mail_when_failure

    attr_reader :id, :user_id, :next_execution, :created_at, :updated_at

    def initialize connection, hash
      super connection
      from_hash hash
    end

    # Delete the task
    def delete
      connection.delete_task id
      nil
    end

    # List the executions for this task
    # <tt>order</tt> can specify the order
    def executions order = nil
      connection.executions(id, order)
    end

    # List the successful executions for this task
    # <tt>order</tt> can specify the order
    def successful_executions order = nil
      connection.successful_executions(id, order)
    end

    # Save the task
    def save
      params = {
          :id => id,
          :name => name,
          :url => url,
          :cron => cron,
          :timezone => timezone,
          :timeout => timeout,
          :enabled=> enabled,
          :mail_when_success => mail_when_success,
          :mail_when_failure => mail_when_failure}
      from_hash(JSON.parse(connection.request :put, "tasks/#{id}", params))
      self
    end

    # List the failed executions for this task
    # <tt>order</tt> can specify the order
    def failed_executions order = nil
      connection.failed_executions(id, order)
    end

    # Get the task's user
    def user
      connection.user(user_id)
    end

    def to_s
      "Task id: [#{id}], name: [#{name}], user_id: [#{user_id}], url: [#{url}], cron: [#{cron}], timezone: [#{timezone}], enabled: [#{enabled}], next_execution: [#{next_execution}], timeout: [#{timeout}], mail when success: #{mail_when_success}, mail when failure: #{mail_when_failure}, created_at: [#{created_at}], updated_at: [#{updated_at}]"
    end

    private

    # Fill the fields from a hash
    def from_hash hash
      @id= hash['id']

      @name= hash['name']
      @user_id= hash['user_id']
      @url= hash['url']
      @cron= hash['cron']
      @timezone= hash['timezone']
      @next_execution= hash.has_key?('next_execution') ? DateTime.parse(hash['next_execution']) : nil
      @enabled= hash['enabled']
      @timeout= hash['timeout']

      @mail_when_success = hash['mail_when_success']
      @mail_when_failure = hash['mail_when_failure']

      @created_at= DateTime.parse(hash['created_at'])
      @updated_at= DateTime.parse(hash['updated_at'])
    end

  end
end