RSpec::Core::Example.class_eval do

  def rapido_run(example_group_instance, reporter)
    @example_group_instance = example_group_instance
    @example_group_instance.example = self

    start(reporter)
    begin
      @example_group_instance.instance_eval(&@example_block)
    rescue RSpec::Core::Pending::PendingDeclaredInExample => e
      @pending_declared_in_example = e.message
    rescue Exception => e
      set_exception(e)
    ensure
      begin
        assign_generated_description
      rescue Exception => e
        set_exception(e, "while assigning the example description")
      end
    end

    finish(reporter)
  end

end
