# frozen_string_literal: true

module Ruby2sass
  class Renderer
    def initialize(&block)
      @output = StringIO.new
      @indentation = 0
      instance_eval(&block) if block_given?
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
      instance_eval(&block)
      dedent
      write_line('}')
    end

    def to_sass
      @output.string
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
end
