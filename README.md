# furcate
[ _verb_ fur-keyt ] _to form a fork; branch._

When you want to enable your users to "branch" and "merge" data the same way you 
branch and merge code, then **furcate** is for you. It replaces `ActiveRecord::Base` 
on your models, storing each change to the model in a separate row in the database. 
Changes are recorded as commits. Together they form snapshots of the data your users
interact with. 

Gems like [paper_trail](https://github.com/paper-trail-gem/paper_trail) and 
[audited](https://github.com/collectiveidea/audited) don't offer branching and merging. And purpose-built datastore 
tools like [TerminusDB](https://terminusdb.com/) and [Dolt](https://www.dolthub.com/) don't have production-ready 
SaaS offerings, and also seem to want collaboration to happen at the data level, rather than the app level, sending us
straight back to the early 2000's when the database was the API and business operation was closely
coupled to the schema making changes impossible.

Furcate operates at the software level, using off-the-shelf, well known relational databases to back
the git-like versioning of data along with branching and merging that so many collaborative apps need
in today's internet. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'furcate'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install furcate

## Usage

```ruby
require 'furcate'

class Team < Furcate::Leaf
end
```

```ruby
team = Team.create("The A Team") 

#switch to a new limb and remove the team
Furcate.create_and_switch_to_limb("cleanup branch")
team.delete

#switch back to the main limb, team is restored
Furcate.switch_to_limb("main")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/TildeWill/furcate. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/TildeWill/furcate/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Furcate project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/furcate/blob/master/CODE_OF_CONDUCT.md).
