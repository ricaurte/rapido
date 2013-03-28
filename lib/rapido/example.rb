module Rapido
  # Your code goes here...
  class Example

    attr_reader :rspec_example_group, :block, :results

    def initialize(rspec_example_group, &block)
      self.rspec_example_group = rspec_example_group
      self.block = block
    end

    def run
      start
      if !pending
        begin
          rspec_example_group.instance_eval(&block)
        rescue Exception => e
          raise unless example
          @exception = e
        end
      end
      finish
    end

    def example
      block.example
    end

    def reporter
      example.rapido_reporter
    end

    def start
      reporter.rapido_example_started self
    end

    def finish
      if @exception
        @exception.extend(NotPendingExampleFixed) unless @exception.respond_to?(:pending_fixed?)
        record_finished 'failed', :exception => @exception
        reporter.rapido_example_failed self
        false
      elsif pending
        record_finished 'pending', :pending_message => String === pending ? pending : Pending::NO_REASON_GIVEN
        reporter.rapido_example_pending self
        true
      else
        record_finished 'passed'
        reporter.rapido_example_passed self
        true
      end
    end

    def pending
      block.nil?
    end

    def record_finished(status, results={})
      finished_at = RSpec::Core::Time.now
      self.results = results.merge(:status => status, :finished_at => finished_at, :run_time => (finished_at - example.execution_result[:started_at]).to_f)
    end

  end

end
