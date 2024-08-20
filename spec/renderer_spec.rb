# frozen_string_literal: true

RSpec.describe Ruby2sass::Renderer do
  describe '#to_sass' do
    it 'generates basic CSS properties' do
      renderer = Ruby2sass::Renderer.new do
        s('.container') do
          width '100%'
          max_width '1200px'
          margin '0 auto'
        end
      end

      expected_output = <<~SASS
        .container {
          width: 100%;
          max-width: 1200px;
          margin: 0 auto;
        }
      SASS

      expect(renderer.to_sass).to eq(expected_output)
    end

    it 'handles nested selectors with yield' do
      renderer = Ruby2sass::Renderer.new do
        s('.parent') do |p|
          color 'black'
          p.child do
            color 'blue'
          end
        end
      end

      expected_output = <<~SASS
        .parent {
          color: black;
          &:child {
            color: blue;
          }
        }
      SASS

      expect(renderer.to_sass).to eq(expected_output)
    end

    it 'processes media queries' do
      renderer = Ruby2sass::Renderer.new do
        media 'screen and (max-width: 600px)' do
          s('.container') do
            width '100%'
          end
        end
      end

      expected_output = <<~SASS
        @media screen and (max-width: 600px) {
          .container {
            width: 100%;
          }
        }
      SASS

      expect(renderer.to_sass).to eq(expected_output)
    end

    it 'handles keyframe animations' do
      renderer = Ruby2sass::Renderer.new do
        keyframes 'fadeIn' do
          s('from') do
            opacity '0'
          end
          s('to') do
            opacity '1'
          end
        end
      end

      expected_output = <<~SASS
        @keyframes fadeIn {
          from {
            opacity: 0;
          }
          to {
            opacity: 1;
          }
        }
      SASS

      expect(renderer.to_sass).to eq(expected_output)
    end

    it 'handles mixins and includes' do
      renderer = Ruby2sass::Renderer.new do
        mixin 'button-styles', '$bg-color' do
          background_color '$bg-color'
          padding '10px 15px'
          border_radius '5px'
        end

        s('.button') do
          include 'button-styles', '#007bff'
        end
      end

      expected_output = <<~SASS
        @mixin button-styles($bg-color) {
          background-color: $bg-color;
          padding: 10px 15px;
          border-radius: 5px;
        }
        .button {
          @include button-styles(#007bff);
        }
      SASS

      expect(renderer.to_sass).to eq(expected_output)
    end

    it 'handles variables with new syntax' do
      renderer = Ruby2sass::Renderer.new do
        my_var = v :primary_color, '#007bff'
        s('.button') do
          background_color my_var
        end
      end

      expected_output = <<~SASS
        $primary_color: #007bff;
        .button {
          background-color: $primary_color;
        }
      SASS

      expect(renderer.to_sass).to eq(expected_output)
    end

    it 'handles imports' do
      renderer = Ruby2sass::Renderer.new do
        import 'variables'
        import 'mixins'
      end

      expected_output = <<~SASS
        @import 'variables';
        @import 'mixins';
      SASS

      expect(renderer.to_sass).to eq(expected_output)
    end

    it 'handles extends' do
      renderer = Ruby2sass::Renderer.new do
        s('.button') do
          extend '.base-button'
          background_color 'blue'
        end
      end

      expected_output = <<~SASS
        .button {
          @extend .base-button;
          background-color: blue;
        }
      SASS

      expect(renderer.to_sass).to eq(expected_output)
    end

    it 'handles if statements' do
      renderer = Ruby2sass::Renderer.new do
        my_var = v :theme, 'dark'
        if_statement "#{my_var} == dark" do
          s('body') do
            background_color 'black'
            color 'white'
          end
        end
        else_statement do
          s('body') do
            background_color 'white'
            color 'black'
          end
        end
      end

      expected_output = <<~SASS
        $theme: dark;
        @if $theme == dark {
          body {
            background-color: black;
            color: white;
          }
        }
        @else {
          body {
            background-color: white;
            color: black;
          }
        }
      SASS

      expect(renderer.to_sass).to eq(expected_output)
    end

    it 'handles for loops with named parameters' do
      renderer = Ruby2sass::Renderer.new do
        for_loop 'i', from: 1, to: 3 do
          s(".col-\#{$i}") do
            width "\#{$i * 25}%"
          end
        end
      end

      expected_output = <<~SASS
        @for $i from 1 through 3 {
          .col-\#{$i} {
            width: \#{$i * 25}%;
          }
        }
      SASS

      expect(renderer.to_sass).to eq(expected_output)
    end

    it 'handles each loops' do
      renderer = Ruby2sass::Renderer.new do
        each_loop 'color', 'red, green, blue' do
          s(".\#{$color}") do
            background_color '$color'
          end
        end
      end

      expected_output = <<~SASS
        @each $color in red, green, blue {
          .\#{$color} {
            background-color: $color;
          }
        }
      SASS

      expect(renderer.to_sass).to eq(expected_output)
    end

    it 'handles while loops' do
      renderer = Ruby2sass::Renderer.new do
        my_var = v :i, 6
        while_loop "#{my_var} > 0" do
          s(".item-\#{$i}") do
            width "\#{$i * 2}em"
          end
          raw "$i: $i - 2;\n"
        end
      end

      expected_output = <<~SASS
    $i: 6;
    @while $i > 0 {
      .item-\#{$i} {
        width: \#{$i * 2}em;
      }
    $i: $i - 2;
    }
      SASS

      expect(renderer.to_sass).to eq(expected_output)
    end

    it 'handles functions' do
      renderer = Ruby2sass::Renderer.new do
        function 'double', '$n' do
          raw "@return $n * 2;\n"
        end
        s('.element') do
          width 'double(5px)'
        end
      end

      expected_output = <<~SASS
    @function double($n) {
    @return $n * 2;
    }
    .element {
      width: double(5px);
    }
      SASS

      expect(renderer.to_sass).to eq(expected_output)
    end

    it 'handles raw SASS input' do
      renderer = Ruby2sass::Renderer.new do
        raw <<~SCSS
          .custom-class {
            display: flex;
            align-items: center;
          }
        SCSS
      end

      expected_output = <<~SASS
        .custom-class {
          display: flex;
          align-items: center;
        }
      SASS

      expect(renderer.to_sass).to eq(expected_output)
    end
  end

  describe '#to_css' do
    it 'renders basic CSS' do
      renderer = Ruby2sass::Renderer.new do
        s('.container') do
          width '100%'
          max_width '1200px'
        end
      end

      css = renderer.to_css
      expect(css).to include('.container {')
      expect(css).to include('width: 100%;')
      expect(css).to include('max-width: 1200px;')
    end

    it 'renders compressed CSS when compress option is true' do
      renderer = Ruby2sass::Renderer.new do
        s('.button') do
          display 'inline-block'
          padding '10px 20px'
          background_color '#007bff'
        end
      end

      css = renderer.to_css(compress: true)
      expect(css).to eq(".button{display:inline-block;padding:10px 20px;background-color:#007bff}\n")
    end

    it 'includes additional SASS content from string' do
      additional_sass = '$primary-color: #007bff;'
      renderer = Ruby2sass::Renderer.new do
        s('.button') do
          background_color '$primary-color'
        end
      end

      css = renderer.to_css(include: [additional_sass])
      expect(css).to include('background-color: #007bff;')
    end

    it 'includes additional SASS content from file' do
      file_path = 'spec/fixtures/variables.sass'
      File.write(file_path, '$secondary-color: #6c757d;') unless File.exist?(file_path)

      renderer = Ruby2sass::Renderer.new do
        s('.text') do
          color '$secondary-color'
        end
      end

      css = renderer.to_css(include: [file_path])
      expect(css).to include('color: #6c757d;')

      File.delete(file_path)
    end

    it 'includes additional SASS content from IO object' do
      io_content = StringIO.new('$font-size: 16px;')
      renderer = Ruby2sass::Renderer.new do
        s('body') do
          font_size '$font-size'
        end
      end

      css = renderer.to_css(include: [io_content])
      expect(css).to include('font-size: 16px;')
    end

    it 'handles multiple includes of different types' do
      file_path = 'spec/fixtures/colors.sass'
      File.write(file_path, '$primary-color: #007bff;') unless File.exist?(file_path)

      additional_sass = '$font-size: 16px;'
      io_content = StringIO.new('$padding: 10px;')

      renderer = Ruby2sass::Renderer.new do
        s('.button') do
          background_color '$primary-color'
          font_size '$font-size'
          padding '$padding'
        end
      end

      css = renderer.to_css(include: [file_path, additional_sass, io_content])
      expect(css).to include('background-color: #007bff;')
      expect(css).to include('font-size: 16px;')
      expect(css).to include('padding: 10px;')

      File.delete(file_path)
    end

    it 'raises an error for unsupported include types' do
      renderer = Ruby2sass::Renderer.new do
        s('.container') do
          width '100%'
        end
      end

      expect {
        renderer.to_css(include: [123])
      }.to raise_error(ArgumentError, /Unsupported include type/)
    end
  end
end
