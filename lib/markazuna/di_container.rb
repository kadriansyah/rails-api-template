require 'dry-container'
require 'dry-auto_inject'
require 'markazuna/cache'

module Markazuna
    class DIContainer
        extend Dry::Container::Mixin

        register :admin_service do
            Admin::AdminService.new
        end

        register :system_cache do
            Markazuna::Cache.instance # return singleton object
        end

    end

    # dependency injection
    INJECT = Dry::AutoInject(Markazuna::DIContainer)
end
