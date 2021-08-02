# frozen_string_literal: true

require_relative 'lib/music_compare/version'

Gem::Specification.new do |spec|
  spec.name          = 'music_compare'
  spec.version       = MusicCompare::VERSION
  spec.authors       = ['Robot-Oleg']
  spec.email         = ['kozelolezhka@gmail.com']

  spec.summary       = 'calculate coincidence(in %) between two music accounts'
  # spec.description   = 'TODO: Write a longer description or delete this line.'
  spec.homepage      = 'https://github.com/Robot-Oleg/music_compare'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.5.0'

  # spec.metadata['allowed_push_host'] = 'TODO: Set to 'https://mygemserver.com''

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Robot-Oleg/music_compare'
  # spec.metadata['changelog_uri'] = 'TODO: Put your gem's CHANGELOG.md URL here.'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'csv'
  spec.add_dependency 'dotenv'
  spec.add_dependency 'fileutils'
  spec.add_dependency 'rspotify'

  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.7'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'webmock'
end
