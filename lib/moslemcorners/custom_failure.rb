class CustomFailure < Devise::FailureApp
    def redirect_url
        if @scope_class == Admin::CoreUser
            '/admin/login'
        else
            '/auth/login' # Admin::CoreAccount
        end
    end

    def respond
        if http_auth?
            http_auth
        else
            redirect
        end
    end
end
