require_dependency 'moslemcorners/auth'

class ApplicationController < ActionController::API
    before_action :authenticate

    def logged_in?
        !!current_user
    end

    def current_user
        if auth_present? && uid_present?
            begin
                decrypted_uid = auth['core_user']
            rescue
                nil
            end
            if decrypted_uid == uid
                core_user = Admin::CoreUser.find(decrypted_uid)
                if core_user
                    @current_user ||= core_user
                else
                    nil
                end
            else
                nil
            end
        else
            nil
        end
    end

    def authenticate
        render json: { status: '404', message: 'unauthorized access' }, status: 401 unless logged_in?
    end

    private
    def token
        request.env['HTTP_AUTHORIZATION'].scan(/Bearer (.*)$/).flatten.last
    end

    def uid
        request.env['HTTP_UID']
    end

    def auth
        MoslemCorners::Auth.decode(token)
    end

    def auth_present?
        # request.headers.each { |key, value|  puts "#{key} => #{value}"}
        !!request.env.fetch('HTTP_AUTHORIZATION','').scan(/Bearer/).flatten.first
    end

    def uid_present?
        !!request.env.fetch('HTTP_UID','')
    end
end
