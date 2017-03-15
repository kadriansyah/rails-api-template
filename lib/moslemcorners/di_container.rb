require 'dry-container'
require 'dry-auto_inject'
require 'moslemcorners/cache'

module MoslemCorners
    class DIContainer
        extend Dry::Container::Mixin

        register 'admin_service' do
            Admin::AdminService.new
        end

        register 'system_cache' do
            MoslemCorners::Cache.instance # return singleton object
        end
    end

    # dependency injection
    INJECT = Dry::AutoInject(MoslemCorners::DIContainer)
end
