RSpec::Core::ExampleGroup.class_eval do

  class << self
    alias_method :run_examples_without_rapido, :run_examples
  end

  # @private
  def self.run_examples_with_rapido(reporter)
    if RSpec.rapido_enabled?
      rapido_run_examples(reporter)
    else
      run_examples_without_rapido(reporter)
    end
  end

  class << self
    alias_method :run_examples, :run_examples_with_rapido
  end

  def self.rapido_run_examples(reporter)
    instance = new
    set_ivars(instance, before_all_ivars)

    all_succeeded = true
    ordered_examples = filtered_examples.ordered
    first_example = ordered_examples.first
    counter = 0
    begin
      first_example.instance_variable_set(:"@example_group_instance", instance)
      instance.example = first_example
      first_example.send :with_around_each_hooks do
        begin
          first_example.send :run_before_each
          all_succeeded = ordered_examples.map do |example|
            next if RSpec.wants_to_quit

            succeeded = example.rapido_run(instance, reporter)

            counter += 1
            RSpec.wants_to_quit = true if fail_fast? && !succeeded
            succeeded
          end.all?
        rescue Exception => e
          if ordered_examples.size == counter
            rapido_report_exception(e)
          else
            all_succeeded = false
            rapido_set_exceptions(reporter, ordered_examples, counter, e)
          end
        ensure
          first_example.send :run_after_each
        end
      end
    rescue Exception => e
      if ordered_examples.size == counter
        rapido_report_exception(e)
      else
        rapido_report_exception(e)
        all_succeeded = false
        rapido_set_exceptions(reporter, ordered_examples, counter, e)
      end
    end if !first_example.nil?
    all_succeeded
  end


  def self.rapido_set_exceptions(reporter, ordered_examples, counter, exception)
    ordered_examples[counter..-1].each do |example|
      example.send(:start, reporter)
      example.set_exception(exception)
      example.send(:finish, reporter)
    end
  end

  def self.rapido_report_exception(exception)
    puts "Exception in example group: #{exception}"
    exception.backtrace.each{|line| puts "  #{line}"}
  end

end
