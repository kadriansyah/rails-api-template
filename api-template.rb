# rails api template (kadriansyah@gmail.com)
# rails new [app_name] --api --skip-active-record -m rails-api-template/api-template.rb

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

# rvm environment related
copy_file '.ruby-gemset'
copy_file '.ruby-version'

# Remove the gemfile so we can start with a clean slate otherwise Rails groups
# the gems in a very strange way
remove_file "Gemfile"
add_file "Gemfile"

prepend_to_file "Gemfile" do
  "source \"https://rubygems.org\""
end

# gems
gem 'rails'
gem 'bootsnap'
gem 'puma'
gem 'jbuilder'
gem 'mongoid'
gem 'dry-container'
gem 'dry-auto_inject'
gem 'redis'
gem 'redis-namespace'
gem 'redis-rails'
gem 'redis-rack-cache'
gem 'sidekiq'
gem 'kaminari-mongoid'
gem 'kaminari-actionview'
gem 'active_model_serializers'
gem 'jwt' # http://www.thegreatcodeadventure.com/jwt-auth-in-rails-from-scratch/
gem 'figaro' # put environment variable on application.yml
gem 'bcrypt'
gem 'swagger-blocks'
gem 'capistrano'

gem_group :development do
    gem 'byebug', platform: :mri
end

gem_group :development, :test do
    gem 'listen'

    # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
    gem 'spring'
    gem 'spring-watcher-listen'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

run 'bundle install'

# copy controllers
directory 'app/controllers', 'app/controllers'

# copy models, serializers, services & value_objects
directory 'app/models', 'app/models'
directory 'app/serializers', 'app/serializers'
directory 'app/services', 'app/services'
directory 'app/value_objects', 'app/value_objects'

# copy lib
directory 'lib', 'lib'

# mongoid
inside 'config' do
    remove_file 'database.yml'
    create_file 'mongoid.yml' do <<-EOF
development:
  # Configure available database clients. (required)
  clients:
    # Defines the default client. (required)
    default:
      # Defines the name of the default database that Mongoid can connect to.
      # (required).
      database: moslemcorner
      # Provides the hosts the default client can connect to. Must be an array
      # of host:port pairs. (required)
      hosts:
        - localhost:27017
      options:
        # Change the default write concern. (default = { w: 1 })
        # write:
        #   w: 1

        # Change the default read preference. Valid options for mode are: :secondary,
        # :secondary_preferred, :primary, :primary_preferred, :nearest
        # (default: primary)
        # read:
        #   mode: :secondary_preferred
        #   tag_sets:
        #     - use: web

        # The name of the user for authentication.
        user: 'moslemcorner'

        # The password of the user for authentication.
        password: 'password'

        # The user's database roles.
        # roles:
        #   - 'dbOwner'

        # Change the default authentication mechanism. Valid options are: :scram,
        # :mongodb_cr, :mongodb_x509, and :plain. (default on 3.0 is :scram, default
        # on 2.4 and 2.6 is :plain)
        # auth_mech: :scram

        # The database or source to authenticate the user against.
        # (default: the database specified above or admin)
        # auth_source: admin

        # Force a the driver cluster to behave in a certain manner instead of auto-
        # discovering. Can be one of: :direct, :replica_set, :sharded. Set to :direct
        # when connecting to hidden members of a replica set.
        # connect: :direct

        # Changes the default time in seconds the server monitors refresh their status
        # via ismaster commands. (default: 10)
        # heartbeat_frequency: 10

        # The time in seconds for selecting servers for a near read preference. (default: 5)
        # local_threshold: 5

        # The timeout in seconds for selecting a server for an operation. (default: 30)
        # server_selection_timeout: 30

        # The maximum number of connections in the connection pool. (default: 5)
        # max_pool_size: 5

        # The minimum number of connections in the connection pool. (default: 1)
        # min_pool_size: 1

        # The time to wait, in seconds, in the connection pool for a connection
        # to be checked in before timing out. (default: 5)
        # wait_queue_timeout: 5

        # The time to wait to establish a connection before timing out, in seconds.
        # (default: 5)
        # connect_timeout: 5

        # The timeout to wait to execute operations on a socket before raising an error.
        # (default: 5)
        # socket_timeout: 5

        # The name of the replica set to connect to. Servers provided as seeds that do
        # not belong to this replica set will be ignored.
        # replica_set: name

        # Whether to connect to the servers via ssl. (default: false)
        # ssl: true

        # The certificate file used to identify the connection against MongoDB.
        # ssl_cert: /path/to/my.cert

        # The private keyfile used to identify the connection against MongoDB.
        # Note that even if the key is stored in the same file as the certificate,
        # both need to be explicitly specified.
        # ssl_key: /path/to/my.key

        # A passphrase for the private key.
        # ssl_key_pass_phrase: password

        # Whether or not to do peer certification validation. (default: true)
        # ssl_verify: true

        # The file containing a set of concatenated certification authority certifications
        # used to validate certs passed from the other end of the connection.
        # ssl_ca_cert: /path/to/ca.cert

  # Configure Mongoid specific options. (optional)
  options:
    # Includes the root model name in json serialization. (default: false)
    # include_root_in_json: false

    # Include the _type field in serialization. (default: false)
    # include_type_for_serialization: false

    # Preload all models in development, needed when models use
    # inheritance. (default: false)
    # preload_models: false

    # Raise an error when performing a #find and the document is not found.
    # (default: true)
    # raise_not_found_error: true

    # Raise an error when defining a scope with the same name as an
    # existing method. (default: false)
    # scope_overwrite_exception: false

    # Use Active Support's time zone in conversions. (default: true)
    # use_activesupport_time_zone: true

    # Ensure all times are UTC in the app side. (default: false)
    # use_utc: false

    # Set the Mongoid and Ruby driver log levels when not in a Rails
    # environment. The Mongoid logger will be set to the Rails logger
    # otherwise.(default: :info)
    # log_level: :info
test:
  clients:
    default:
      database: dummy_test
      hosts:
        - localhost:27017
      options:
        read:
          mode: :primary
        max_pool_size: 1

        EOF
    end
end

# copy config
directory "config", "config"

# configure routing
insert_into_file 'config/routes.rb', after: "Rails.application.routes.draw do\n" do <<-EOF
    root to: redirect('/swagger/dist/index.html?url=/apidocs')
    resources :apidocs, only: [:index]
    scope :admin do
        root to: 'admin#index'
        resources :users, controller: 'admin/users' do
            get 'delete', on: :member # http://guides.rubyonrails.org/routing.html#adding-more-restful-actions
            put 'update', on: :collection
        end
    end
    EOF
end

# adding cache config to development environments
insert_into_file 'config/environments/development.rb', before: /^end/ do <<-RUBY

    # api cache directory
    config.api_cache_directory = "\#{Rails.root}/public/cached"
    RUBY
end

# adding cache config to production environments
insert_into_file 'config/environments/production.rb', before: /^end/ do <<-RUBY

    # api cache directory
    config.api_cache_directory = "\#{Rails.root}/public/cached"
    RUBY
end

# kaminari config
generate('kaminari:config')

# # clone swagger-ui using 1.2 specification
# inside('public') do
#     run 'git clone --branch v2.2.10 https://github.com/swagger-api/swagger-ui.git swagger'
# end

# # clone swagger-ui using 2.0 specification
# inside('public') do
#     run 'git clone --branch v3.0.21 https://github.com/swagger-api/swagger-ui.git swagger'
# end

# copy swagger-ui & generate API Documentation
directory 'public/swagger', 'public/swagger'
# run 'rails swagger:blocks'

# capistrano
run 'bundle exec cap install'
gsub_file 'config/deploy.rb', /set :application.*$/, ""
gsub_file 'config/deploy.rb', /set :repo_url.*$/, ""
gsub_file 'config/deploy.rb', /#.*$/, ""
insert_into_file 'config/deploy.rb', after: /lock.*$/ do <<-EOF

set :application, 'appname'
set :rvm_ruby_version, '2.5.1@api-template'

# Select a gemset
# example ruby-2.3.3@rails
set :rvm_ruby_version, 'ruby-X.X.X@name_of_gemset'

# URL to the repository.
set :repo_url, 'ssh://git@example.com:30000/~/me/my_repo.git'

# The branch name to be deployed
set :branch, 'master'

set :user,  '<ssh user>'
set :use_sudo,  false
set :ssh_options,   { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }

# for staging, use development environment
if fetch(:stage) == 'staging'
  set :rails_env, :development
else
  set :rails_env, fetch(:stage)
end

set :deploy_to, "/var/www/html/\#{fetch(:application)}"

# how many old releases do we want to keep
set :keep_releases, 3

# # There is a known bug that prevents sidekiq from starting when pty is true on Capistrano 3.
# set :pty, false

# files we want symlinking to specific entries in shared
set :linked_files, fetch(:linked_files, []).push('config/application.yml', 'config/mongoid.yml', 'config/secrets.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Passenger
set :passenger_roles, :app
set :passenger_restart_runner, :sequence
set :passenger_restart_wait, 5
set :passenger_restart_limit, 2
set :passenger_restart_with_sudo, false
# set :passenger_environment_variables, {}
set :passenger_restart_command, 'passenger-config restart-app'
set :passenger_restart_options, -> { "\#{deploy_to} --ignore-app-not-running" }

# # Sidekiq
# set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }
    EOF
end

# production.rb
insert_into_file 'config/deploy/production.rb', after: /# server "db.example.com".*$\n/ do <<-EOF

set :stage, :production
server '<ip address production>', port: '<ssh port for production>', user: '<ssh user for production>', roles: %w{app db web}, primary: true

    EOF
end

# staging.rb
insert_into_file 'config/deploy/staging.rb', after: /# server "db.example.com".*$\n/ do <<-EOF

set :stage, :staging
server '<ip address staging>', port: '<ssh port for staging>', user: '<ssh user for staging>', roles: %w{app db web}, primary: true

    EOF
end

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
