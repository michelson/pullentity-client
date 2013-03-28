# Pullentity::Client

This gem provides a simple builder workspace for make pullentity sites with haml and sass

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

  since its a middleman app you can

    middleman s or middleman server

Setup your credentials

    pullentity login your@email.com

Choose the site you want to export theme.

    pullentity select_site

Export and install the theme for your site.

    pullentity export



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# TODO , path for 0.1.0

1. upload assets.
2. import data
3. OK setup task (login + select site)
4. OK make default task
5. load remote data
6. use mustache server side
