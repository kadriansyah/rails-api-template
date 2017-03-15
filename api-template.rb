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
gem "rails", "~> 5.0.2"
gem 'puma', '~> 3.0'
gem 'jbuilder'
gem 'mongoid'
gem 'dry-container'
gem 'dry-auto_inject'
gem 'redis'
gem 'redis-namespace'
gem 'redis-rails'
gem 'redis-rack-cache'
gem 'sidekiq'
gem 'devise'
gem 'kaminari-mongoid'
gem 'kaminari-actionview'
gem 'active_model_serializers'

gem_group :development do
    gem 'byebug', platform: :mri
end

gem_group :development, :test do
    gem 'listen', '~> 3.0.5'

    # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
    gem 'spring'
    gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

run 'bundle install'

# copy serializers, services & value_objects
directory 'app/serializers', 'app/serializers'
directory 'app/services', 'app/services'
directory 'app/value_objects', 'app/value_objects'

# copy moslemcorners lib
directory 'lib/moslemcorners', 'lib/moslemcorners'

# # mongoid
# generate('mongoid:config')
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
      database: quran
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

#
# devise
generate('devise:install')

# copy devise.rb
copy_file "config/initializers/devise.rb", "config/initializers/devise.rb"

# prepare devise
generate('devise admin/core_user')
generate('devise:controllers admin/core_user')
generate('devise:views admin/core_user')

# adding dependency
insert_into_file 'app/models/admin/core_user.rb', before: "class Admin::CoreUser\n" do <<-RUBY
    require 'moslemcorners/common_model'

    RUBY
end

# adding MoslemCorners::CommonModel & collection name
insert_into_file 'app/models/admin/core_user.rb', after: "include Mongoid::Document\n" do <<-RUBY
    include MoslemCorners::CommonModel
    store_in collection: 'core_users'

    # kaminari page setting
    paginates_per 20

    RUBY
end

# adding fields to core_user
insert_into_file 'app/models/admin/core_user.rb', before: "end" do <<-RUBY

    # non devise field
    field :username, type: String, default: ''
    field :firstname, type: String, default: ''
    field :lastname, type: String, default: ''

    RUBY
end

# configure routing
insert_into_file 'config/routes.rb', after: "Rails.application.routes.draw do\n" do <<-RUBY

    devise_for :core_user, class_name: 'Admin::CoreUser', module: :devise,
               path: 'admin', path_names: { sign_in: 'login', sign_out: 'logout' },
               :controllers => {
                   sessions: 'admin/core_user/sessions',
                   registrations: 'admin/core_user/registrations',
                   passwords: 'admin/core_user/passwords'
               }

    root to: 'index#index'

    scope :admin do
        root to: 'admin#index'

        resources :users, controller: 'admin/user' do
            get 'delete', on: :member # http://guides.rubyonrails.org/routing.html#adding-more-restful-actions
        end
    end
    RUBY
end

# remove default routing generated by devise
gsub_file 'config/routes.rb', /devise_for :core_users, class_name: "Admin::CoreUser"/, ''

# copy controllers
copy_file 'app/controllers/admin_controller.rb', 'app/controllers/admin_controller.rb'
copy_file 'app/controllers/admin/user_controller.rb', 'app/controllers/admin/user_controller.rb'

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

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
