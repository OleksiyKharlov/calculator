# Calculator

Requirements:
Calculator which calculates commission amount and net amount depending on input params.

1. Write Ruby gem - Calculator, which calculates commission amount and net
    amount depending on input params
2. Input
     - amount *required
     - commission_amount *optional
     - commission_percent *optional
     - commission_entity(user, product) *optional
     Output -
    [net_amount, commission_amount]
3. If there's no commission - then it's set by default.
4. Possibility to change commission depending on:
     - product type
     - user
     - product price(amount)
5. Code should be covered with unit tests.
6. Possibility to calculate commission with two digits after decimal point precision.
    Calculator.call(amount: 100, commission_amount: 1.0, commission_percent: 20)
    commission_total = 100.0 * 0.2 + 1.0 = 21.0
    net_amount = 100.0 - 21.0 = 79.0
     => [79.0, 21.0]

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'calculator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install calculator

## Usage
```ruby
Calculator.call(amount: 100, commission_amount: 1.0, commission_percent: 20)
```

commission_total = 100.0 * 0.2 + 1.0 = 21.0

net_amount = 100.0 - 21.0 = 79.0

Result: [79.0, 21.0]

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/calculator.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
