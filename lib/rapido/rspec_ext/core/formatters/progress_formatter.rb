Rspec::Core::Formatters::ProgressFormatter.class_eval do

  def rapido_example_passed(example)
    super(example)
    output.print success_color('$')
  end

  def rapido_example_pending(example)
    super(example)
    output.print pending_color('?')
  end

  def rapido_example_failed(example)
    super(example)
    output.print failure_color('X')
  end

end
