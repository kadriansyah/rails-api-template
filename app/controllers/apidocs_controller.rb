require 'swagger/blocks'
require 'admin/users_controller'
require 'admin/core_user'

class ApidocsController < ActionController::Base
    include Swagger::Blocks

    swagger_root do
        key :swagger, '2.0'
        info do
            key :version, '1.0.0'
            key :title, 'MoslemCorners API Template'
            key :description, 'MoslemCorners API Template using swagger-2.0 specification'
            key :termsOfService, 'https://policies.google.com/terms?hl=en&gl=id'
            contact do
                key :name, 'MoslemCorners API Team'
            end
            license do
                key :name, 'MIT'
            end
        end
        tag do
            key :name, 'MoslemCorners'
            key :description, 'MoslemCorners Operations'
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
        Admin::CreateResponse,
        Admin::EditResponse,
        Common::Response,
        self,
    ].freeze

    def index
        render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
    end
end