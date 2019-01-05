# Sekrat::Crypter::Aes

This is a Sekrat::Crypter implementation that uses the AES-256-GCM algorithm to encrypt/decrypt the data handed to it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sekrat-crypter-aes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sekrat-crypter-aes

## Usage

To use this Crypter with a Sekrat::Manager, you do something like this:

```ruby
require 'sekrat'
require 'sekrat/crypter/aes'

confidant = Sekrat.manager(crypter: Sekrat::Crypter::Aes)
```

Now, when you `confidant.put` secrets, they will be encrypted pretty strongly.

***NOTE: The encrypted payloads that result from this algorithm are basically made of binary data, so if you're using a storage mechanism that doesn't do well with that sort of thing (like plain old filesystem files), it might not be a bad idea to make sure that said storage mechanism either uses the proper encoding or transforms to a non-binary format.***

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sekrat/sekrat-crypter-aes-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sekrat::Crypter::Aes project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sekrat-crypter-aes/blob/master/CODE_OF_CONDUCT.md).
