module HTTPCronClient

  class Execution < HTTPCronClientObject

    attr_reader :id, :task_id, :status, :run_at, :duration, :response

    def initialize connection, hash
      super connection
      from_hash hash
    end

   # Delete the execution
    def delete
      connection.delete_execution id
      nil
    end

    # Get the execution's task
    def task
      connection.task(task_id)
    end

    def to_s
      "Execution id: [#{id}], task_id: [#{task_id}], status: [#{status}], run_at: [#{run_at}], duration: [#{duration}]"
    end

    private

    # Fill the fields from a hash
    def from_hash hash
      @id= hash['id']

      @task_id= hash['task_id']
      @status= hash['status']
      @run_at= DateTime.pase(hash['run_at'])
      @duration= hash['duration']
      @response= hash['response']
    end

  end
end