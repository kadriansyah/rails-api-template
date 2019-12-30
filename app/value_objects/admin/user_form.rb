require 'swagger/blocks'

module Admin
    class UserForm
        include ActiveModel::Model
        include Swagger::Blocks

        attr_accessor(
            :id,
            :email,
            :username,
            :password,
            :confirmation_password,
            :firstname,
            :lastname
        )

        attr_reader :core_user

        # Validations
        validates :email, presence: true
        validates :username, presence: true
        validates :password, presence: true
        validates :confirmation_password, presence: true

        swagger_schema 'Admin::UserForm' do
            key :required, [:email, :username, :password, :firstname, :lastname]
            property :email do
                key :type, :string
            end
            property :username do
                key :type, :string
            end
            property :password do
                key :type, :string
            end
            property :confirmation_password do
                key :type, :string
            end
            property :firstname do
                key :type, :string
            end
            property :lastname do
                key :type, :string
            end
        end

        def save
            if valid?
                begin
                    @core_user = Admin::CoreUser.new(email: self.email,
                                                     username: self.username,
                                                     password: self.password,
                                                     firstname: self.firstname,
                                                     lastname: self.lastname)
                    @core_user.save
                    true
                rescue
                    false
                end
            else
                false
            end
        end

        def update
            if valid?
                begin
                    @core_user = Admin::CoreUser.find(self.id)
                    @core_user.update_attributes!(email: self.email,
                                                  username: self.username,
                                                  password: self.password,
                                                  firstname: self.firstname,
                                                  lastname: self.lastname)
                    true
                rescue
                    false
                end
            else
                false
            end
        end
    end
end
