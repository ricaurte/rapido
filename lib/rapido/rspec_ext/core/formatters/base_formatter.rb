Rspec::Core::Formatters::BaseFormatter.class_eval do

  attr_reader :rapido_examples
  attr_reader :rapido_example_count, :rapido_pending_count, :rapido_failure_count
  attr_reader :rapido_failed_examples, :rapido_pending_examples

  def initialize_with_rapido(output)
    initialize_without_rapido(output)
    @rapido_examples_count = @rapido_pending_count = @rapido_failure_count = 0
    @rapido_examples = []
    @rapido_failed_examples = []
    @rapido_pending_examples = []
  end
  alias_method_chain :initialize, :rapido

  def rapido_example_started(example)
    rapido_examples << example
  end

  def rapido_example_passed(example)
  end

  def rapido_example_pending(example)
    @rapido_pending_examples << example
  end

  def rapido_example_failed(example)
    @rapido_failed_examples << example
  end

end

