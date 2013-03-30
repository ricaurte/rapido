Rspec::Core::Example.class_eval do

  attr_reader :rapido_reporter


  def run_with_rapido(example_group_instance, reporter)
    return run_without_rapido(example_group_instance, reporter) if !Rspec.rapido_enabled?

    @example_group_instance = example_group_instance
    @example_group_instance.example = self

    start(reporter)
    begin
      @example_group_instance.instance_eval(&@example_block)
    rescue Pending::PendingDeclaredInExample => e
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
  alias_method_chain :run, :rapido

end
