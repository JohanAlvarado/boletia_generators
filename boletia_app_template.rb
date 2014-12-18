GENERATOR_TEMPLATE_PATH = "~/.boletia_rails_generator_template"
remove_file "README.rdoc"
create_file "README.md", @app_name.capitalize

create_file ".ruby-version", '2.0.0-p195'

run "rvm gemset create #{@app_name}"
create_file ".ruby-gemset", @app_name

#Especify ruby version to be at least version 2.0.0-p195
inject_into_file "Gemfile", after: "source 'https://rubygems.org'\n\n" do <<-'RUBY'
  ruby '2.0.0'
RUBY
end

gem_group :test do
  gem 'spork-rails', '~> 4.0.0'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'capybara', '~> 2.4.4'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'rspec-sidekiq', '~> 2.0.0'
  gem 'poltergeist', '~> 1.5.1'
  gem 'phantomjs', '~> 1.9.7.1'
  gem 'guard-rails', '~> 0.7.0'
  gem 'guard', '~> 2.10.4'
  gem 'shoulda-matchers', '~> 2.7.0'
  gem 'timecop', '~> 0.7.1'
  gem 'vcr', '~> 2.9.3'
  gem 'webmock', '~> 1.20.4'
end

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'pry'
  gem 'ffaker'
end

gem_group :production do
  gem "rails_12factor"
end

#Generates rspec config
generate "rspec:install"

#Configures spec/spec_helper.rb file
directory "#{GENERATOR_TEMPLATE_PATH}/rspec_support_files", 'spec/support', :recursive => false

inject_into_file 'spec/spec_helper.rb', after: "require 'rspec/rails'\n" do <<-'RUBY'
require 'email_spec'
RUBY
end

#Configures application.rb
application do
  "# don't generate RSpec tests for views and helpers
  config.generators do |g|
    g.test_framework :rspec, fixture: true
    g.fixture_replacement :factory_girl, dir: 'spec/factories'
    g.view_specs true
    g.helper_specs true
    g.stylesheets = false
    g.javascripts = false
    g.helper = false
  end

  config.autoload_paths += %W(\#{config.root}/lib)"
end

"git init"

#Git configuration
git :init
append_file ".gitignore", "/config/database.yml\n"
append_file ".gitignore", ".sass-cache/*\n"
append_file ".gitignore", ".DS_Store\n"
append_file ".gitignore", "*.dump\n"
append_file ".gitignore", "/public/uploads\n" #For when using carrierwave later on

run "cp config/database.yml config/example_database.yml"
