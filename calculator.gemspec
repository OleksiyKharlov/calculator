lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'calculator/version'

Gem::Specification.new do |spec|
  spec.name    = 'calculator'
  spec.version = Calculator::VERSION
  spec.authors = ['Oleksiy Kharlov']
  spec.email   = ['alex.harlov@gmail.com']

  spec.summary     = 'Calculator which calculates commission amount and net '\
                        'amount depending on input params.'
  spec.description =
    "1. Write Ruby gem - Calculator, which calculates commission amount and net
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
    "
  spec.homepage    = "https://github.com/OleksiyKharlov/calculator"
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 5.2'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
