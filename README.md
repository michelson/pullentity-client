# Pullentity::Client

This gem provides a simple builder workspace for make [pullentity](http://pullentity.com/) sites with haml and sass

## Installation

Add this line to your application's Gemfile:

    gem 'pullentity-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pullentity-client

## Usage

### commands

Create project

    pullentity project new your_theme_name

Run project

    pullentity s # or pullentity server

  since it's a middleman app you can

    middleman s or middleman server

Setup (login, site selection & import data)

    pullentity setup your@email.com

Setup your credentials

    pullentity login your@email.com

Choose the site you want to export theme.

    pullentity select_site

Export and install the theme for your site.

    pullentity theme export

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
