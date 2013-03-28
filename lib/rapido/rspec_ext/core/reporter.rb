Rspec::Core::Reporter.class_eval do

  def rapido_example_started(example)
    notify :rapido_example_started, example
  end

  def rapido_example_passed(example)
    notify :rapido_example_passed, example
  end

  def rapido_example_pending(example)
    notify :rapido_example_pending, example
  end

  def rapido_example_failed(example)
    notify :rapido_example_failed, example
  end

end

