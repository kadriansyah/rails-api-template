require 'bcrypt'
require 'swagger/blocks'
require 'markazuna/common_model'

class Admin::CoreUser
    include BCrypt # Admin::CoreUser.password_hash in the database is a :string
    include Mongoid::Document
    include Swagger::Blocks
    include Markazuna::CommonModel
    store_in collection: 'core_users'

    swagger_schema 'Admin::CoreUser' do
        key :required, [:email, :username, :firstname, :lastname, :token, :password_hash]
        property :email do
            key :type, :string
        end
        property :username do
            key :type, :string
        end
        property :firstname do
            key :type, :string
        end
        property :lastname do
            key :type, :string
        end
        property :token do
            key :type, :string
        end
        property :password_hash do
            key :type, :string
        end
    end

    # kaminari page setting
    paginates_per 20

    field :email, type: String, default: ''
    field :username, type: String, default: ''
    field :firstname, type: String, default: ''
    field :lastname, type: String, default: ''
    field :token, type: String, default: ''
    field :password_hash, type: String, default: ''

    def password
        @password ||= Password.new(password_hash)
    end

    def password=(new_password)
        @password = Password.create(new_password)
        self.password_hash = @password
    end

    def authenticate(password)
        password_created = BCrypt::Password.create(password)
        password_created == self.password_hash
    end
end
