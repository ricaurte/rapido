Rspec::Core::ExampleGroup.class_eval do

  # @private
  # instance_evals the block, capturing and reporting an exception if
  # raised. Unlike instance_eval_with_rescue, it also saves the passing
  # and exception data
  def rpd(context = nil, &block)
    rapido = Rapido::Example.new(self, &block)
    rapido_examples << rapido
    rapido.run
  end
  alias_method :ex, :rpd
  alias_method :r, :rpd

end
