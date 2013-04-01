# Rapido

Rapido makes it so you don't have to wait forever for your test suite when you follow the better specs guidelines and do one assertion per it.  Rapido extends Rspec so that you can have specs that run fast and are also very descriptive.  Use your existing test suite with no or minor modifications and just run

    RAPIDO=true rspec spec

And see your tests run much faster, up to 5-6x faster!

## Installation

Add this line to your application's Gemfile:

    gem 'rapido'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rapido

## Usage

In order to make your test suite rapido compatible, you need to make sure that the code you put inside of your it assertions in rspec do not cause any side effects as your it's will all run inside of the same context instead of having the context instance variables reset.

    # Good
    before do
      @number = 1
    end

    it { @number.should == 1 }

    # Bad
    before do
      @number = 1
    end

    it do
      @number = 4
      @number.should == 4
    end
    it { @number.should == 1 } # will fail

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
