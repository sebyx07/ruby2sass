# frozen_string_literal: true

module Ruby2sass
  class Renderer
    def initialize(&block)
      @output = StringIO.new
      @indentation = 0
      @input_block = block
      @variables = {}
    end

    CSS_PROPERTIES.each do |property|
      method_name = property.tr('-', '_').delete('@')

      if property.start_with?('@')
        define_method(method_name) do |*args, &block|
          write_line("#{property} #{args.join(' ')} {")
          indent
          instance_eval(&block) if block_given?
          dedent
          write_line('}')
        end
      else
        define_method(method_name) do |value|
          write_line("#{property}: #{value};")
        end
      end
    end

    def s(selector, &block)
      write_line("#{selector} {")
      indent
      if block.arity == 1
        block.call(SelectorContext.new(self))
      else
        instance_eval(&block)
      end
      dedent
      write_line('}')
    end

    def media(*args, &block)
      write_line("@media #{args.join(' ')} {")
      indent
      instance_eval(&block) if block_given?
      dedent
      write_line('}')
    end

    def keyframes(name, &block)
      write_line("@keyframes #{name} {")
      indent
      instance_eval(&block) if block_given?
      dedent
      write_line('}')
    end

    def mixin(name, *args, &block)
      args_str = args.empty? ? '' : "(#{args.join(', ')})"
      write_line("@mixin #{name}#{args_str} {")
      indent
      instance_eval(&block) if block_given?
      dedent
      write_line('}')
    end

    def include(name, *args)
      args_str = args.empty? ? '' : "(#{args.join(', ')})"
      write_line("@include #{name}#{args_str};")
    end

    def v(name, value)
      @variables[name] = "$#{name}"
      write_line("$#{name}: #{value};")
      @variables[name]
    end

    def import(path)
      write_line("@import '#{path}';")
    end

    def extend(selector)
      write_line("@extend #{selector};")
    end

    def if_statement(condition, &block)
      write_line("@if #{condition} {")
      indent
      instance_eval(&block) if block_given?
      dedent
      write_line('}')
    end

    def else_statement(&block)
      write_line('@else {')
      indent
      instance_eval(&block) if block_given?
      dedent
      write_line('}')
    end

    def for_loop(variable, from:, to:, &block)
      write_line("@for $#{variable} from #{from} through #{to} {")
      indent
      instance_eval(&block) if block_given?
      dedent
      write_line('}')
    end

    def each_loop(variable, list, &block)
      write_line("@each $#{variable} in #{list} {")
      indent
      instance_eval(&block) if block_given?
      dedent
      write_line('}')
    end

    def while_loop(condition, &block)
      write_line("@while #{condition} {")
      indent
      instance_eval(&block) if block_given?
      dedent
      write_line('}')
    end

    def function(name, *args, &block)
      args_str = args.empty? ? '' : "(#{args.join(', ')})"
      write_line("@function #{name}#{args_str} {")
      indent
      instance_eval(&block) if block_given?
      dedent
      write_line('}')
    end

    def return(value)
      write_line("@return #{value};")
    end

    def raw(sass_content)
      @output << sass_content
    end

    def to_sass
      return @sass_output if @sass_output
      instance_eval(&@input_block) if @input_block

      @sass_output = @output.string
    end

    def to_css(include: nil, compress: false)
      Ruby2sass::CssRender.new(to_sass, include, compress).render
    end

    def method_missing(method_name, *args)
      property = method_name.to_s.tr('_', '-')
      value = args.first
      write_line("#{property}: #{value};")
    end

    private
      def write_line(line)
        @output.puts('  ' * @indentation + line)
      end

      def indent
        @indentation += 1
      end

      def dedent
        @indentation -= 1
      end
  end

  class SelectorContext
    def initialize(renderer)
      @renderer = renderer
    end

    def method_missing(method_name, *args, &block)
      selector = "&:#{method_name}"
      @renderer.s(selector, &block)
    end
  end
end
