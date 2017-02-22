# FFS

FFS provides a quick and flexible way to get up and running with
[Firebase Dynamic Links](https://firebase.google.com/docs/dynamic-links/)
through a minimal API.

## Installation

FFS works with Rails 4.1 onwards. Add it to your Gemfile with:

```ruby
gem 'ffs'
```

Then run `bundle install`.

Next, run the generator to create the initializer:

```ruby
$ rails generate f_f_s:install
```

Once the generator completes, you will be presented with instructions to
complete the setup of FFS. You will need to set up your application's settings
in `config/initializers/ffs.rb`. A minimal configuration utilizing Firebase's
link shortening and accommodating Android and iOS can be seen here:

```ruby
FFS.configure do |config|
  # ==> General configuration
  config.firebase_api_key = 'my_firebase_api_key'
  config.dynamic_link_domain = 'mydomain.app.goo.gl'
  config.suffix = 'SHORT'

  # ==> Android configuration
  config.android_package_name = 'my_package_name'

  # ==> iOS configuration
  config.ios_bundle_id = 'my_bundle_id'
  config.ios_app_store_id = 'my_app_store_id'
end
```

You should utilize environment variables for any API keys and other sensitive
information you don't want made public.
For a full explanation of each configuration option, check the
[Firebase dynamic links documentation](https://firebase.google.com/docs/reference/dynamic-links/link-shortener).

## Usage

FFS provides a single public method to generate your dynamic link. After customizing the initializer to your needs, create a new instance of `FFS::Share`:

```ruby
ffs = FFS::Share.new
```

Next, call `#generate_dynamic_link`, which takes two arguments: A hash containing basic information to be displayed when your link is shared to a social network, and an optional hash to turn features off and on, depending on your needs. Here's an example utilizing `#generate_dynamic_link`'s default options:

```ruby
link_info = {
  link: 'www.example.com/user/1',
  socialMetaTagInfo: {
    socialTitle: 'My Social Media Title',
    socialDescription: 'Description of the thing being shared.',
    socialImageLink: 'http://i.imgur.com/d5ByxBl.png'
  }
}

ffs.generate_dynamic_link(link_info)
```

This returns a hash containing the short link and a link to view a flowchart of
where the link will take you in a variety of situations.

```ruby
{
  "shortLink": "https://yourdomain.app.goo.gl/randomString",
  "previewLink": "https://yourdomain.app.goo.gl/?link=http://www.example.com&apn=com.example.hello"
}
```

![Flowchart](http://i.imgur.com/qanlwcs.png)

### Advanced Usage

Imagine we have this model:

```ruby
class Author < ApplicationRecord
  validates :name, :bio, :picture
end
```

We want to pass this object to FFS to create a shareable link to post to Twitter.
Since `#generate_dynamic_link` takes a hash as its first argument, it allows
us to do this:

```ruby
walt = Author.new(
  name: 'Walt Whitman',
  bio: 'American poet, essayist, and journalist.',
  picture: 'walt.jpg'
)
ffs = FFS::Share.new

def author_info(author)
  {
    link: "www.example.com/author/#{author.id}",
    socialMetaTagInfo: {
      socialTitle: author.name,
      socialDescription: author.bio,
      socialImageLink: author.picture
    }
  }
end

link_info = author_info(walt)

ffs.generate_dynamic_link(link_info)
```

### Options

Below is a table of options you can pass to `#generate_dynamic_link`, along with their default value:

| Option  | Default Value | Description |
| ------------- | ------------- | ------------- |
| android  | true | Include metadata for Android. |
| ios | true | Include metadata for iOS. |
| min_package | false | Restrict the dynamic link to certain app versions. (Android) |
| ipad | false | Include separate metadata for iPad |
| custom_scheme | false | Define a custom URL scheme for your app. (iOS) |
| fallback | false | Provide a link to open when the app isn't installed. |
| analytics | false | Collect analytics using Google Play and/or iTunes. |
| bitly | false | Use Bitly for link shortening instead of Firebase. |

Utilize options like this:

```ruby
ffs = FFS::Share.new

# We don't need metadata for iOS, want Google Play analytics, and want to use Bitly.
ffs.generate_dynamic_link(link_info, ios: false, analytics: true, bitly: true)
```

Detailed explanations can be found in the
[Firebase documentation](https://firebase.google.com/docs/reference/dynamic-links/link-shortener#parameters)

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/goronfreeman/ffs.

## License

MIT

Copyright (c) 2017 Hunter Braun

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
