class Admin::CoreUserEditResponse
    include Swagger::Blocks

    swagger_schema 'Admin::CoreUserEditResponse' do
        key :required, [:status, :payload]
        property :status do
            key :type, :string
        end
        property :payload do
            key :'$ref', 'Admin::CoreUser'
        end
    end
end