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
                @core_user = Admin::CoreUser.new(email: self.email,
                                                 username: self.username,
                                                 password: self.password,
                                                 firstname: self.firstname,
                                                 lastname: self.lastname)
                @core_user.save
                true
            else
                false
            end
        end

        def update
            if valid?
                @core_user = Admin::CoreUser.find(self.id)
                @core_user.update_attributes!(email: self.email,
                                              username: self.username,
                                              password: self.password,
                                              firstname: self.firstname,
                                              lastname: self.lastname)
                true
            else
                false
            end
        end
    end
end
