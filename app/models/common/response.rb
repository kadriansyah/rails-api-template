class Common::Response
    include Swagger::Blocks

    swagger_schema 'Common::Response' do
        key :required, [:status, :message]
        property :status do
            key :type, :string
        end
        property :message do
            key :type, :string
        end
    end
end