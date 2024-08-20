# frozen_string_literal: true

require_relative 'ruby2sass/version'
require_relative 'ruby2sass/css_properties'
Dir.glob(File.join(__dir__, 'ruby2sass', '**', '*.rb')).each do |file|
  require file
end

module Ruby2sass
  class Error < StandardError; end
  # Your code goes here...
end
