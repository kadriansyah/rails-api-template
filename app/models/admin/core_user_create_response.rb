class Admin::CoreUserCreateResponse
    include Swagger::Blocks

    swagger_schema 'Admin::CoreUserCreateResponse' do
        key :required, [:status, :message, :uid, :token]
        property :status do
            key :type, :string
        end
        property :message do
            key :type, :string
        end
        property :uid do
            key :type, :string
        end
        property :token do
            key :type, :string
        end
    end
end