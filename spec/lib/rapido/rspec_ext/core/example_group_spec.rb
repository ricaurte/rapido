$: << File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', '..', '..'))
require 'spec/spec_helper'

module RSpec::Core
  describe ExampleGroup do

    let(:world) { w = World.new; w.stub(filter_manager: filter_manager); w }
    let(:filter_manager) { FilterManager.new }

    let(:example_group) { RSpec::Core::ExampleGroup.describe }
    let(:reporter) { RSpec::Core::Configuration.new.reporter }

    class RapidlyExceptioning < Exception; end

    def setup_example_group(group)
      group.stub(world: world)
      group.register
      world.instance_variable_get(:"@filtered_examples")[group] = begin
        examples = group.examples.dup
        examples = world.filter_manager.prune(examples)
        examples.uniq
        examples.extend(Extensions::Ordered::Examples)
      end
      group
    end

    describe ".rapido_run_examples" do

      context "example group not sent a block" do

        let(:example_group) do
          group = RSpec::Core::ExampleGroup.describe
          setup_example_group(group)
        end

        before do
          example_group.rapido_run_examples(reporter)
        end

        it { example_group.examples.count.should == 0 }

      end

      context "example group has no examples in a block" do

        let(:example_group) do
          group = RSpec::Core::ExampleGroup.describe do
          end
          setup_example_group(group)
        end

        before do
          example_group.rapido_run_examples(reporter)
        end

        it { example_group.examples.count.should == 0 }

      end

      context "example group has examples without blocks" do

        let(:example_group) do
          group = RSpec::Core::ExampleGroup.describe do
            it "should be pending"
            it "should also be pending"
          end
          setup_example_group(group)
        end

        before do
          example_group.rapido_run_examples(reporter)
        end

        it { example_group.examples.count.should == 2 }
        it { example_group.examples[0].exception.should == nil }
        it { example_group.examples[0].pending.should == "Not yet implemented" }
        it { example_group.examples[1].exception.should == nil }
        it { example_group.examples[1].pending.should == "Not yet implemented" }

      end


      context "example group has simple examples" do

        let(:example_group) do
          group = RSpec::Core::ExampleGroup.describe do
            it { (1 + 5).should == 6 }
            it { (1 + 6).should == 7 }
          end
          setup_example_group(group)
        end

        before do
          example_group.rapido_run_examples(reporter)
        end

        it { example_group.examples[0].exception.should == nil }
        it { example_group.examples[1].exception.should == nil }

      end

      context "an example in an example group modifies the instance variables" do

        let(:example_group) do
          group = RSpec::Core::ExampleGroup.describe do

            before do
              @name = "chimichunga"
            end

            it { @name.should == "chimichunga" }
            it { @name = "hey dude" }
            it { @name.should == "chimichunga" }

          end
          setup_example_group(group)
        end

        before do
          example_group.rapido_run_examples(reporter)
        end

        it { example_group.filtered_examples[0].exception.should == nil }
        it { example_group.filtered_examples[1].exception.should == nil }
        it { example_group.filtered_examples[2].exception.should_not == nil }
        it { example_group.filtered_examples[2].exception.class.name.should == "RSpec::Expectations::ExpectationNotMetError" }
        it { example_group.filtered_examples[2].exception.to_s.should == "expected: \"chimichunga\"\n     got: \"hey dude\" (using ==)" }

      end

      context "check before each" do

        let(:example_group) do
          group = RSpec::Core::ExampleGroup.describe do
            let!(:count) do
              @count ||= 0
              @count += 1
            end

            it { @count.should == 1 }
            it { @count.should == 1 }
            it { @count.should == 1 }

          end
          setup_example_group(group)
        end

        before do
          example_group.rapido_run_examples(reporter)
        end

        it { example_group.filtered_examples[0].exception.should == nil }
        it { example_group.filtered_examples[1].exception.should == nil }
        it { example_group.filtered_examples[2].exception.should == nil }

      end

      context "parent has before's" do

        it "should run the parent before's"

      end

      context "after each" do

        it "should only be run once"

      end

      context "an exception occurs before the examples run" do

        let(:example_group) do
          group = RSpec::Core::ExampleGroup.describe do

            before do
              raise RapidlyExceptioning
            end

            it { 1.should == 1 }
            it { 2.should == 2 }

          end
          setup_example_group(group)
        end

        before do
          example_group.rapido_run_examples(reporter)
        end

        it "should give the first example the exception" do
          example_group.examples.first.exception.class.should == RapidlyExceptioning
        end

        it "should give the second example the exception" do
          example_group.examples[1].exception.class.should == RapidlyExceptioning
        end

        it "should give both the same exception" do
          example_group.examples.first.exception.should == example_group.examples[1].exception
        end

      end

      context "retrieving meta data in the before" do

        let(:example_group) do
          group = RSpec::Core::ExampleGroup.describe do

            before do
              @metadata = example.metadata
            end

            it("hello!", meta: :stuff) { @metadata[:meta].should == :stuff }

          end
          setup_example_group(group)
        end

        before do
          example_group.rapido_run_examples(reporter)
        end

        it { example_group.filtered_examples[0].exception.should == nil }

      end

    end

  end

end