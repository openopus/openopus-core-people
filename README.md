# Openopus::Core::People
Model the real world of people in your application, making user interaction robust. By way of example, a person can have many email addresses, but this is not usually represented in applications.  openopus/core/people creates the database structure, relations, and convenience functions for your application so you don't have to.  Just connect your end user model, and away you go.

## Usage
Install the gem, run migrations.  This will create human structures, from Organization down to people (Person).  More documentation and usage examples will be forthcoming.

```ruby
  opus = Organization.where(name: "Opus Logica, Inc").first_or_create(nicknames_attributes: [{ nickname: "OPUS" }])
  bfox = User.lookup("bfox@opuslogica.com") ||
         User.create(person_attributes: { email: "bfox@opuslogica.com", name: "Brian Jhan Fox",
                                          address: "901 Olive St., Santa Barbara, CA, 93101",
                                          phone: "805.555.8642" },
                     organization: opus,
                     credentials_attributes: [{ password: "idtmp2tv" }])
```
## Installation
Add this line to your application's Gemfile:

```ruby
gem 'openopus-core-people', git: "https://github.com/openopus/openopus-core-people"
```

And then execute:
```bash
$ bundle install
$ bundle exec rake db:migrate
```

Or install it yourself as:
```bash
$ gem install openopus-core-people
```

## Contributing
Got an idea for an improvement?  Think this thing is *almost* good, but still kinda sucks?  Create an issue, and we'll get back to you ASAP.  Please discuss code contributions with us before hand so that we can agree on the architecture.  Otherwise, we might not be able to take your improvements.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
