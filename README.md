# TimeOverlap

Simple command line tool that allows to find overlap hours between two time zones, with visualization.

```
$ time_overlap count 8 16 +00:00 Bangkok 4
```

![screenshot](http://i68.tinypic.com/mi1npd.png)

Assuming that you are in Bangkok and the target time zone is UTC +0
and you want to cover 4 hours - from 8:00 to 16:00.

In most cases it suggests 2 options (cover first 4 hours: 8-12 or last: 12-16).

More info: https://www.daxx.com/blog/offshore-team/time-difference-offshore-development

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'time_overlap'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install time_overlap

## Usage


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/time_overlap. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TimeOverlap project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/time_overlap/blob/master/CODE_OF_CONDUCT.md).
