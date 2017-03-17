module Admin
    class UserForm
        include ActiveModel::Model

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

        def save
            if valid?
                begin
                    Admin::CoreUser.find_by(username: self.username)
                    false
                rescue
                    @core_user = Admin::CoreUser.new(email: self.email,
                                                     username: self.username,
                                                     password: self.password,
                                                     firstname: self.firstname,
                                                     lastname: self.lastname)
                    @core_user.save
                    true
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
