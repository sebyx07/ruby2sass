# frozen_string_literal: true

module Ruby2sass
  class CssRender
    def initialize(sass, include, compress)
      @sass = sass
      @included_files = include
      @compress = compress
    end

    def render
      combined_sass = process_includes + @sass
      options = {
        style: @compress ? :compressed : :expanded
      }

      SassC::Engine.new(combined_sass, **options).render
    end

    private
      def process_includes
        return '' unless @included_files

        Array(@included_files).map do |include_item|
          content = case include_item
                    when String
                      if File.exist?(include_item)
                        File.read(include_item)
                      else
                        include_item
                      end
                    when IO, StringIO
                      include_item.read
                    else
                      raise ArgumentError, "Unsupported include type: #{include_item.class}"
          end
          content + "\n"
        end.join
      end
  end
end
