require 'swagger/blocks'
require 'admin/users_controller'
require 'admin/core_user'

class ApidocsController < ActionController::Base
    include Swagger::Blocks

    swagger_root do
        key :swagger, '2.0'
        info do
            key :version, '1.0.0'
            key :title, 'Markazuna API Template'
            key :description, 'Markazuna API Template using swagger-2.0 specification'
            key :termsOfService, 'https://policies.google.com/terms?hl=en&gl=id'
            contact do
                key :name, 'Markazuna API Team'
            end
            license do
                key :name, 'MIT'
            end
        end
        tag do
            key :name, 'Markazuna'
            key :description, 'Markazuna Operations'
            externalDocs do
                key :description, 'Find more info here'
                key :url, 'https://swagger.io'
            end
        end
        key :host, 'localhost:3000'
        key :basePath, '/'
        key :consumes, ['application/json']
        key :produces, ['application/json']
    end

    # A list of all classes that have swagger_* declarations.
    SWAGGERED_CLASSES = [
        Admin::UsersController,
        Admin::CoreUser,
        Admin::UserForm,
        Admin::CoreUserCreateResponse,
        Admin::CoreUserEditResponse,
        Common::Response,
        self,
    ].freeze

    def index
        render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
    end
end