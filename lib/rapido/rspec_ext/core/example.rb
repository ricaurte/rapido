Rspec::Core::Example.class_eval do

  attr_reader :rapido_reporter

  def initialize_with_rapido(example_group_class, description, metadata, example_block=nil)
    initialize_without_rapido(example_group_class, description, metadata, example_block)

    if !@example_block.nil?
      def @example_block.example
        @_example
      end

      @example_block.set_instance_variable :"@_example", self
    end
  end
  alias_method_chain :initialize, :rapido

  def run_with_rapido(example_group_instance, reporter)
    @rapido_reporter = reporter
    run_without_rapido(example_group_instance, report)
  end
  alias_method_chain :run, :rapido

end
