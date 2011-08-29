module HTTPCronClient

  class Task < HTTPCronClientModel

    attr_accessor :name, :url, :timeout, :enabled, :cron, :timezone

    attr_reader :id, :user_id, :next_execution, :created_at, :updated_at

    def initialize connection, hash
      super connection
      from_hash hash
    end

    # List the executions for this task
    # <tt>order</tt> can specify the order
    def executions order = nil
      connection.executions(id, order)
    end

    # Delete the task
    def delete
      connection.delete_task id
      nil
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
          :enabled=> enabled}
      from_hash(JSON.parse(connection.request :put, "tasks/#{id}", params))
      self
    end

    # Get the task's user
    def user
      connection.user(user_id)
    end

    def to_s
      "Task id: [#{id}], name: [#{name}], user_id: [#{user_id}], url: [#{url}], cron: [#{cron}], timezone: [#{timezone}], enabled: [#{enabled}], next_execution: [#{next_execution}], timeout: [#{timeout}], created_at: [#{created_at}], updated_at: [#{updated_at}]"
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

      @created_at= DateTime.parse(hash['created_at'])
      @updated_at= DateTime.parse(hash['updated_at'])
    end

  end
end