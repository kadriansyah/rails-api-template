namespace :deploy do
    desc 'Create Symbolic Link from current_path/public/page_cache to /var/www/html/fs-pool/alomobile'
    task :fs_pool do
        on roles(:app) do
            within "#{current_path}" do
                # execute "ln -s /var/www/html/cache-pool #{current_path}/public/page_cache"
                execute "ln -s /var/www/html/fs-pool/alomobile #{current_path}/public/page_cache"
            end
        end
    end
    after :deploy, 'deploy:fs_pool'
end
