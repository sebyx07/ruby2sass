# Ruby2sass 🎨

Ruby2sass is a powerful and flexible Ruby DSL for generating SASS and CSS. It allows you to write your stylesheets using Ruby syntax, providing a more programmatic and dynamic approach to stylesheet generation. 🚀

## Installation 💻

Add this line to your application's Gemfile:

```ruby
gem 'ruby2sass'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ruby2sass

## Usage 🔨

Here's a basic example of how to use Ruby2sass:

```ruby
require 'ruby2sass'

renderer = Ruby2sass::Renderer.new do
  s('.container') do
    width '100%'
    max_width '1200px'
    margin '0 auto'

    s('&__header') do
      background_color '#f0f0f0'
      padding '20px'

      s('h1') do
        font_size '24px'
        color '#333'
      end
    end
  end
end

puts renderer.to_sass
puts renderer.to_css
```

### `to_sass` Method 📝

The `to_sass` method generates SASS output from your Ruby2sass DSL. It doesn't take any arguments:

```ruby
sass_output = renderer.to_sass
```

### `to_css` Method 🎭

The `to_css` method compiles your Ruby2sass DSL directly to CSS. It accepts two optional parameters:

```ruby
css_output = renderer.to_css(include: nil, compress: false)
```

- `include`: An array of file paths, strings, or IO objects to be included before the main SASS content. This can be used to include variables, mixins, or other SASS partials.
- `compress`: A boolean indicating whether the output CSS should be compressed (default is false).

Example with options:

```ruby
css_output = renderer.to_css(
  include: ['path/to/variables.sass', '$primary-color: #007bff;'],
  compress: true
)
```

## Performance 🏎️

Ruby2sass is designed to handle various sizes of SASS structures efficiently. Here are some benchmark results:

```
Structure Details:
Small (Depth: 3, Breadth: 3):
  Total Selectors: 39
  Total Properties: 117
  SASS Size: 3.74 KB
  CSS Size: 3.96 KB
Medium (Depth: 4, Breadth: 4):
  Total Selectors: 340
  Total Properties: 1020
  SASS Size: 36.13 KB
  CSS Size: 39.14 KB
Large (Depth: 5, Breadth: 5):
  Total Selectors: 3905
  Total Properties: 11715
  SASS Size: 455.77 KB
  CSS Size: 502.50 KB

Benchmark Results:
     Ruby2sass small:    145.5 i/s
    Ruby2sass medium:     20.0 i/s - 7.29x  slower
     Ruby2sass large:      1.7 i/s - 84.77x  slower
```

These results show that Ruby2sass can handle small to medium-sized stylesheets very efficiently, while still being capable of processing larger stylesheets. 📊

## Development 🛠️

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing 🤝

Bug reports and pull requests are welcome on GitHub at https://github.com/sebyx07/ruby2sass.

## License 📄

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).