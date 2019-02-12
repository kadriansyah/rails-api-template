require 'swagger/blocks'
require_dependency 'markazuna/auth'

class ApplicationController < ActionController::API
    include ActionController::MimeResponds
    include Swagger::Blocks
    before_action :authenticate

    def verified?
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
                begin
                    core_user = Admin::CoreUser.find(decrypted_uid)
                    @current_user ||= core_user
                rescue
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
        render json: { status: '401', message: 'unauthorized access' }, status: 401 unless verified?
    end

    private
    def token
        request.env['HTTP_AUTHORIZATION'].scan(/Bearer (.*)$/).flatten.last
    end

    def uid
        request.env['HTTP_UID']
    end

    def auth
        Markazuna::Auth.decode(token)
    end

    def auth_present?
        # request.headers.each { |key, value|  puts "#{key} => #{value}"}
        !!request.env.fetch('HTTP_AUTHORIZATION','').scan(/Bearer/).flatten.first
    end

    def uid_present?
        !!request.env.fetch('HTTP_UID','')
    end
end
