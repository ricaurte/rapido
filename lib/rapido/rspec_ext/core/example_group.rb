Rspec::Core::ExampleGroup.class_eval do


  # @private
  def self.run_examples_with_rapido(reporter)
    if Rspec.rapido_enabled?
      rapido_run_examples(reporter)
    else
      run_examples_without_rapid(reporter)
    end
  end

  class << self
    alias_method_chain :run_examples, :rapido
  end

  def self.rapido_run_examples(reporter)
    instance = new
    set_ivars(instance, before_all_ivars)

    all_succeeded = true
    first_example = filtered_examples.first
    counter = 0
    ordered_examples = filtered_examples.ordered
    begin
      first_example.with_around_each_hooks do
        begin
          first_example.run_before_each
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
            rapido_set_exceptions(ordered_examples, counter, e)
          end
        ensure
          first_example.run_after_each
        end
      end
    rescue Exception => e
      if ordered_examples.size == counter
        rapido_report_exception(e)
      else
        all_succeeded = false
        rapido_set_exceptions(ordered_examples, counter, e)
      end
    end
    all_succeeded
  end


  def self.rapido_set_exceptions(ordered_examples, counter, exception)
    ordered_examples[counter..-1].each do |example|
      example.start(reporter)
      example.set_exception(exception)
      example.finish(reporter)
    end
  end

  def self.rapido_report_exception(exception)
    puts "Exception in example group: #{exception}"
    exception.backtrace.each{|line| puts "  #{line}"}
  end

end
