require 'moslemcorners/common_model'
require 'bcrypt'

class Admin::CoreUser
    include BCrypt # Admin::CoreUser.password_hash in the database is a :string
    include Mongoid::Document
    include MoslemCorners::CommonModel
    store_in collection: 'core_users'

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
