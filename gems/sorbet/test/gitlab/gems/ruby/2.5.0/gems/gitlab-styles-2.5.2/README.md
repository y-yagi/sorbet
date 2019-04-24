# Gitlab::Styles

`Gitlab::Styles` centralizes some shared GitLab's styles config (only RuboCop
for now), as well as custom RuboCop cops.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gitlab-styles', require: false
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gitlab-styles

## Usage

### Inherit all rules

Include the following in your `.rubocop.yml` and remove all the rules that are
already in `rubocop-default.yml`:

```yaml
inherit_gem:
  gitlab-styles:
    - rubocop-default.yml
```

### Inherit only some kind of rules

The rules are grouped by type so you can choose to inherit only some kind of
rules:

- `rubocop-all.yml`
- `rubocop-bundler.yml`
- `rubocop-gemspec.yml`
- `rubocop-layout.yml`
- `rubocop-lint.yml`
- `rubocop-metrics.yml`
- `rubocop-naming.yml`
- `rubocop-performance.yml`
- `rubocop-rails.yml`
- `rubocop-rspec.yml`
- `rubocop-security.yml`
- `rubocop-style.yml`

Example:

```yaml
inherit_gem:
  gitlab-styles:
    - rubocop-gemspec.yml
    - rubocop-naming.yml
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and merge requests are welcome on GitLab at
https://gitlab.com/gitlab-org/gitlab-styles. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to adhere
to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `Gitlab::Styles` project’s codebases, issue trackers,
chat rooms and mailing lists is expected to follow the
[code of conduct](https://gitlab.com/gitlab-org/gitlab-styles/blob/master/CODE_OF_CONDUCT.md).
