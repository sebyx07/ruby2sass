# Ruby2sass 🎨

Ruby2sass is a powerful and flexible Ruby DSL for generating SASS and CSS. It allows you to write your stylesheets using Ruby syntax, providing a more programmatic and dynamic approach to stylesheet generation. 🚀

## Installation 💻

Add this line to your application's Gemfile:

```ruby
gem 'ruby2sass'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install ruby2sass
```

## Usage 🔨

Here's a comprehensive example showcasing various features of Ruby2sass, along with the generated SASS output for each block:

```ruby
require 'ruby2sass'

renderer = Ruby2sass::Renderer.new do
  # Variables
  primary_color = v('primary-color', '#007bff')
  secondary_color = v('secondary-color', '#6c757d')
  grid_columns = v('grid-columns', 12)

  s('body') do
    background_color primary_color
  end
end

puts renderer.to_sass
```

Output:

```scss
$primary-color: #007bff;
$secondary-color: #6c757d;
$grid-columns: 12;

body {
  background-color: #007bff;
}
```

```ruby
renderer = Ruby2sass::Renderer.new do
  # Mixins
  mixin 'button-styles', '$bg-color' do
    background_color '$bg-color'
    padding '10px 15px'
    border_radius '5px'
    transition 'background-color 0.3s ease'
  end

  # Functions
  function 'darken', '$color, $amount' do
    raw '@return darken($color, $amount);'
  end
end

puts renderer.to_sass
```

Output:

```scss
@mixin button-styles($bg-color) {
  background-color: $bg-color;
  padding: 10px 15px;
  border-radius: 5px;
  transition: background-color 0.3s ease;
}

@function darken($color, $amount) {
  @return darken($color, $amount);
}
```

```ruby
renderer = Ruby2sass::Renderer.new do
  # Base styles
  s('body') do
    font_family "'Arial', sans-serif"
    line_height '1.6'
    color '#333'
  end

  # Container
  s('.container') do
    max_width '1200px'
    margin '0 auto'
    padding '0 15px'
  end
end

puts renderer.to_sass
```

Output:

```scss
body {
  font-family: 'Arial', sans-serif;
  line-height: 1.6;
  color: #333;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 15px;
}
```

```ruby
renderer = Ruby2sass::Renderer.new do
  primary_color = v('primary-color', '#007bff')
  secondary_color = v('secondary-color', '#6c757d')

  # Buttons
  s('.button') do |btn|
    include 'button-styles', primary_color

    btn.hover do
      background_color "darken(#{primary_color}, 10%)"
    end
  end

  s('.button-secondary') do |btn|
    include 'button-styles', secondary_color

    btn.hover do
      background_color "darken(#{secondary_color}, 10%)"
    end
  end
end

puts renderer.to_sass
```

Output:

```scss
$primary-color: #007bff;
$secondary-color: #6c757d;

.button {
  @include button-styles(#007bff);
  &:hover {
    background-color: darken(#007bff, 10%);
  }
}

.button-secondary {
  @include button-styles(#6c757d);
  &:hover {
    background-color: darken(#6c757d, 10%);
  }
}
```

```ruby
renderer = Ruby2sass::Renderer.new do
  grid_columns = v('grid-columns', 12)

  # Grid system using for loop
  for_loop 'i', from: 1, to: grid_columns do
    s(".col-\#{$i}") do
      width "calc(100% / #{grid_columns} * \#{$i})"
      float 'left'
      padding '0 15px'
    end
  end
end

puts renderer.to_sass
```

Output:

```scss
$grid-columns: 12;

@for $i from 1 through 12 {
  .col-#{$i} {
    width: calc(100% / 12 * #{$i});
    float: left;
    padding: 0 15px;
  }
}
```

```ruby
renderer = Ruby2sass::Renderer.new do
  # Color palette using each loop
  colors = v('colors', '("primary": #007bff, "secondary": #6c757d, "success": #28a745, "danger": #dc3545)')
  each_loop 'name, color', colors do
    s(".\#{$name}-bg") do
      background_color '$color'
    end
    s(".\#{$name}-text") do
      color '$color'
    end
  end
end

puts renderer.to_sass
```

Output:

```scss
$colors: ("primary": #007bff, "secondary": #6c757d, "success": #28a745, "danger": #dc3545);

@each $name, $color in $colors {
  .#{$name}-bg {
    background-color: $color;
  }
  .#{$name}-text {
    color: $color;
  }
}
```

```ruby
renderer = Ruby2sass::Renderer.new do
  # Responsive font sizes using while loop
  base_font = v('base-font-size', 16)
  i = v('i', 6)
  while_loop "#{i} > 0" do
    s("h\#{$i}") do
      font_size "#{base_font} + \#{$i}px"
    end
    raw "#{i} = #{i} - 1;"
  end
end

puts renderer.to_sass
```

Output:

```scss
$base-font-size: 16;
$i: 6;

@while $i > 0 {
  h#{$i} {
    font-size: 16 + #{$i}px;
  }
$i: $i - 1;
}
```

```ruby
renderer = Ruby2sass::Renderer.new do
  # Media queries
  breakpoints = v('breakpoints', '("sm": 576px, "md": 768px, "lg": 992px, "xl": 1200px)')
  each_loop 'name, width', breakpoints do
    media "screen and (min-width: \#{$width})" do
      s('.container') do
        max_width '$width'
      end
    end
  end
end

puts renderer.to_sass
```

Output:

```scss
$breakpoints: ("sm": 576px, "md": 768px, "lg": 992px, "xl": 1200px);

@each $name, $width in $breakpoints {
  @media screen and (min-width: #{$width}) {
    .container {
      max-width: $width;
    }
  }
}
```

```ruby
renderer = Ruby2sass::Renderer.new do
  # Theme switching with if-else
  theme = v('theme', 'light')
  if_statement "#{theme} == 'light'" do
    s('body') do
      background_color '#fff'
      color '#333'
    end
  end
  else_statement do
    s('body') do
      background_color '#333'
      color '#fff'
    end
  end
end

puts renderer.to_sass
```

Output:

```scss
$theme: light;

@if $theme == 'light' {
  body {
    background-color: #fff;
    color: #333;
  }
}
@else {
  body {
    background-color: #333;
    color: #fff;
  }
}
```

```ruby
renderer = Ruby2sass::Renderer.new do
  # Using raw SASS for complex selectors
  raw <<~SCSS
    nav {
      ul {
        margin: 0;
        padding: 0;
        list-style: none;

        li { display: inline-block; }

        a {
          display: block;
          padding: 6px 12px;
          text-decoration: none;
        }
      }
    }
  SCSS
end

puts renderer.to_sass
```

Output:

```scss
nav {
  ul {
    margin: 0;
    padding: 0;
    list-style: none;

    li { display: inline-block; }

    a {
      display: block;
      padding: 6px 12px;
      text-decoration: none;
    }
  }
}
```

This example demonstrates:
- Variable declaration using `v()` and usage
- Mixins and includes
- Custom functions
- Nested selectors with yield
- Various types of loops (for, each, while) for generating classes and styles
- Media queries with dynamic breakpoints
- Conditional statements for theming
- Raw SASS input for complex nesting

### `to_sass` Method 📝

The `to_sass` method generates SASS output from your Ruby2sass DSL:

```ruby
sass_output = renderer.to_sass
```

### `to_css` Method 🎭

The `to_css` method compiles your Ruby2sass DSL directly to CSS:

```ruby
css_output = renderer.to_css(include: nil, compress: false)
```

Parameters:
- `include`: An array of file paths, strings, or IO objects to be included before the main SASS content.
- `compress`: A boolean indicating whether the output CSS should be compressed (default is false).

Example with options:

```ruby
css_output = renderer.to_css(
  include: ['path/to/variables.sass', '$primary-color: #007bff;'],
  compress: true
)
```

## Features 🌟

Ruby2sass supports:
- Variables with `v()` method
- Mixins and includes
- Custom functions
- Nested selectors with yield for pseudo-classes and pseudo-elements
- Loops (for, each, while) with various use cases
- Conditionals (if-else)
- Media queries with dynamic breakpoints
- Keyframe animations
- Raw SASS input for complex scenarios
- CSS property method missing for easy property setting

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