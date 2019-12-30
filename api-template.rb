## rails api template (kadriansyah@gmail.com)
# rails new [app_name] --api --skip-active-record -m rails-api-template/api-template.rb

## scaffolding for model
# ./generator.sh scaffold --name Core::Category --fields "id,name,description" --service_name Core::CategoryService

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

# _templates generator
directory '_templates'

copy_file 'generator.sh'
run 'chmod +x generator.sh'

# rvm environment related
copy_file '.ruby-gemset'
gsub_file '.ruby-gemset', /#appname/, "#{@app_name}"
copy_file '.ruby-version'

# docker
copy_file 'build.sh'
gsub_file 'build.sh', /#appname/, "#{@app_name}"
run 'chmod +x build.sh'

copy_file 'network.sh'

copy_file 'run.sh'
gsub_file 'run.sh', /#appname/, "#{@app_name}"
run 'chmod +x run.sh'

copy_file 'docker-compose.yml'
copy_file 'docker-entrypoint.sh'
copy_file 'Dockerfile'
copy_file 'rails_s.sh'
run 'chmod +x rails_s.sh'

copy_file 'reload.sh'
gsub_file 'reload.sh', /#appname/, "#{@app_name}"
run 'chmod +x reload.sh'

copy_file 'init_db.sh'
gsub_file 'init_db.sh', /#appname/, "#{@app_name}"
run 'chmod +x init_db.sh'

copy_file 'production_log.sh'
gsub_file 'production_log.sh', /#appname/, "#{@app_name}"
run 'chmod +x production_log.sh'

gsub_file 'docker-compose.yml', /#appname/, "#{@app_name}"
gsub_file 'Dockerfile', /#appname/, "#{@app_name}"

# nginx virtual host (be carefull with backslash on location, we need to escape it using double backslash)
add_file "#{@app_name}.com"
append_to_file "#{@app_name}.com", <<-EOF
server {
    # Permanent redirect to www
    server_name #{@app_name}.com;
    rewrite ^/(.*)$ https://www.#{@app_name}.com/$1 permanent;
}

server {
    listen 8080;
    server_name #{@app_name}.com;

    # Tell Nginx and Passenger where your app's 'public' directory is
    root /var/www/html/#{@app_name}.com/public;

    # Prevent (deny) Access to Hidden Files with Nginx
    location ~ /\\. {
        access_log off;
        log_not_found off; 
        deny all;
    }

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    # set the expire date to max for assets
    location ~ "^/assets/(.*/)*.*-[0-9a-f]{32}.*" {
        gzip_static on;
        expires     max;
        add_header  Cache-Control public;
    }

    error_page  405     =200 $uri;

    location / {
        try_files /page_cache/$request_uri @passenger;
    }

    location @passenger {
        passenger_enabled on;
        passenger_user app;
        passenger_ruby /usr/local/bin/ruby;
        passenger_app_env production;
        passenger_min_instances 100;
    }
}

server {
    listen 8443;

    ssl     on;
    ssl_certificate     /etc/ssl/#{@app_name}.pem;
    ssl_certificate_key     /etc/ssl/#{@app_name}.key;

    server_name www.#{@app_name}.com;

    # Tell Nginx and Passenger where your app's 'public' directory is
    root /var/www/html/#{@app_name}.com/public;

    # Prevent (deny) Access to Hidden Files with Nginx
    location ~ /\. {
        access_log off;
        log_not_found off; 
        deny all;
    }

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    # set the expire date to max for assets
    location ~ "^/assets/(.*/)*.*-[0-9a-f]{32}.*" {
        gzip_static on;
        expires     max;
        add_header  Cache-Control public;
    }

    error_page  405     =200 $uri;

    location / {
        try_files /page_cache/$request_uri @passenger;
    }

    location @passenger {
        passenger_enabled on;
        passenger_user app;
        passenger_ruby /usr/local/bin/ruby;
        passenger_app_env production;
        passenger_min_instances 100;
    }
}
EOF

# kubernetes
directory 'kube'

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
gem 'tzinfo-data'

gem_group :development do
    gem 'byebug', platform: :mri
end

gem_group :development, :test do
    gem 'listen'

    # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
    gem 'spring'
    gem 'spring-watcher-listen'
end

# bundle
run 'bundle install'

# update bundler using newest version
run 'bundle update --bundler'

# copy controllers
directory 'app/controllers', 'app/controllers'

# copy models, serializers, services & value_objects
directory 'app/models', 'app/models'
directory 'app/serializers', 'app/serializers'
directory 'app/services', 'app/services'
directory 'app/value_objects', 'app/value_objects'

# copy lib
directory 'lib', 'lib'

# add hygen code generator
run 'yarn add hygen'

# prevent from check_yarn_integrity issue
run 'yarn install --check-files'

# copy config
directory "config", "config"

# mongoid
remove_file 'config/database.yml'
gsub_file 'config/mongoid.yml', /#dbname/, "#{@app_name}"
gsub_file 'config/mongoid.yml', /#hostname/, "mongo"

# configure routing
insert_into_file 'config/routes.rb', after: "Rails.application.routes.draw do\n" do <<-EOF
    root to: redirect('/swagger/index.html?url=/apidocs')
    resources :apidocs, only: [:index]
    scope :admin do
        root to: 'admin#index', as: 'admin_index'
        # http://guides.rubyonrails.org/routing.html#adding-more-restful-actions
        resources :users, controller: 'admin/users', only: [:index, :create, :update] do 
            delete 'delete', on: :member
            get 'edit', on: :member
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

# capistrano
run 'bundle exec cap install'
gsub_file 'config/deploy.rb', /set :application.*$/, ""
gsub_file 'config/deploy.rb', /set :repo_url.*$/, ""
gsub_file 'config/deploy.rb', /#.*$/, ""
insert_into_file 'config/deploy.rb', after: /lock.*$/ do <<-EOF

set :application, '#{@app_name}'
set :rvm_ruby_version, '2.5.1@#{@app_name}'

set :repo_url, 'git@github.com:kadriansyah/#{@app_name}.git'
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
  run 'echo node_modules >> .gitignore'
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
