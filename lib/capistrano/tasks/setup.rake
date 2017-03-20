namespace :setup do

    desc 'Upload database.yml file.'
    task :upload_yml do
        on roles(:app) do
            execute "mkdir -p #{shared_path}/config"
            upload! StringIO.new(File.read('config/application.yml')), "#{shared_path}/config/application.yml"
            upload! StringIO.new(File.read('config/mongoid.yml')), "#{shared_path}/config/mongoid.yml"
            upload! StringIO.new(File.read('config/secrets.yml')), "#{shared_path}/config/secrets.yml"
        end
    end

    desc 'Create MongoDB Indexes'
    task :mongo_create_index do
        on roles(:app) do
            within "#{current_path}" do
                if fetch(:stage) == 'staging'
                    with rails_env: :development do
                        execute :rake, 'db:mongoid:create_indexes'
                    end
                else
                    with rails_env: fetch(:stage) do
                        execute :rake, 'db:mongoid:create_indexes'
                    end
                end
            end
        end
    end

    desc 'Remove MongoDB Indexes'
    task :mongo_remove_index do
        on roles(:app) do
            within "#{current_path}" do
                if fetch(:stage) == 'staging'
                    with rails_env: :development do
                        execute :rake, 'db:mongoid:remove_indexes'
                    end
                else
                    with rails_env: fetch(:stage) do
                        execute :rake, 'db:mongoid:remove_indexes'
                    end
                end
            end
        end
    end

    desc 'Create MongoDB Indexes Single Collection'
    task :single_mongo_create_index do
        on roles(:app) do
            within "#{current_path}" do
                if fetch(:stage) == 'staging'
                    with rails_env: :development do
                        execute :rake, "index_single_collection:create MODEL=#{ENV['MODEL']}"
                    end
                else
                    with rails_env: fetch(:stage) do
                        execute :rake, "index_single_collection:create MODEL=#{ENV['MODEL']}"
                    end
                end
            end
        end
    end

    desc 'Remove MongoDB Indexes Single Collection'
    task :single_mongo_remove_index do
        on roles(:app) do
            within "#{current_path}" do
                if fetch(:stage) == 'staging'
                    with rails_env: :development do
                        execute :rake, "index_single_collection:remove MODEL=#{ENV['MODEL']}"
                    end
                else
                    with rails_env: fetch(:stage) do
                        execute :rake, "index_single_collection:remove MODEL=#{ENV['MODEL']}"
                    end
                end
            end
        end
    end

    desc 'Seed the database.'
    task :seed_db do
        on roles(:app) do
            within "#{current_path}" do
                if fetch(:stage) == 'staging'
                    with rails_env: :development do
                        execute :rake, 'db:seed'
                    end
                else
                    with rails_env: fetch(:stage) do
                        execute :rake, 'db:seed'
                    end
                end
            end
        end
    end

    desc 'Clear Cache.'
    task :clear_cache do
        on roles(:web), in: :groups, limit: 3, wait: 10 do
            within "#{current_path}" do
                if fetch(:stage) == 'staging'
                    with rails_env: :development do
                        execute :rake, 'cache:clear'
                    end
                else
                    with rails_env: fetch(:stage) do
                        execute :rake, 'cache:clear'
                    end
                end
            end
        end
    end
end
