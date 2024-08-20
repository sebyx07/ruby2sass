# frozen_string_literal: true

require_relative 'lib/ruby2sass/version'

Gem::Specification.new do |spec|
  spec.name = 'ruby2sass'
  spec.version = Ruby2sass::VERSION
  spec.authors = ['sebi']
  spec.email = ['gore.sebyx@yahoo.com']

  spec.summary = 'A Ruby DSL for generating SASS stylesheets'
  spec.description = 'Ruby2sass provides a flexible and intuitive way to write SASS stylesheets using Ruby syntax. It supports all CSS properties, nested selectors, and special at-rules.'
  spec.homepage = 'https://github.com/sebyx07/ruby2sass'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/sebyx07/ruby2sass'
  spec.metadata['changelog_uri'] = 'https://github.com/sebyx07/ruby2sass/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'sassc', '>= 2.4'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
