class Admin::EditResponse
    include Swagger::Blocks

    swagger_schema 'Admin::EditResponse' do
        key :required, [:status, :payload]
        property :status do
            key :type, :string
        end
        property :payload do
            key :'$ref', 'Admin::CoreUser'
        end
    end
end