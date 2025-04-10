# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "rubyrag"
  spec.version = "0.1.0"
  spec.authors = ["Max Rukomoynikov"]
  spec.email = ["rukomoynikov@gmail.com"]

  spec.summary = "Cloudflare AutoRag integration for Ruby on Rails applications"
  spec.description = "Seamlessly integrate Cloudflare AutoRag into your Ruby on Rails applications with this gem. It provides a simple and idiomatic Ruby interface for leveraging AutoRag’s automatic retrieval-augmented generation (RAG) pipeline—making it easy to connect your app’s data with powerful AI models using Cloudflare Workers and Vectorize."
  spec.homepage = "https://github.com/rukomoynikov/rubyrag"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.7"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  spec.add_development_dependency "debug", ">= 1.0.0"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_dependency "aws-sdk-s3"
  spec.add_dependency "libxml-ruby"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
