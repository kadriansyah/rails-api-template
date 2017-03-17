require_dependency 'moslemcorners/auth'

module Admin
    class AdminService
        def create_user(user_form)
            if user_form.save
                token = MoslemCorners::Auth.issue({core_user: user_form.core_user.id.to_s}) # use to_s because we don't want $OID
                user_form.core_user.update_attribute(:token, token)
                return token, user_form.core_user.id.to_s
            else
                nil
            end
        end

        def update_user(user_form)
            begin
                user_form.update
            rescue
                false
            end
        end

        def delete_user(id)
            core_user = find_user(id)
            core_user.delete
        end

        def find_user(id)
            Admin::CoreUser.find(id)
        end

        def find_users(page = 0)
            Admin::CoreUser.page(page)
        end
    end
end
