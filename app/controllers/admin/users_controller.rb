require_dependency 'moslemcorners/api_cache'
require_dependency 'moslemcorners/di_container'

module Admin
    class UsersController < ApplicationController
        include MoslemCorners::APICache
        include MoslemCorners::INJECT['admin_service']

        before_action :authenticate, except: [:create]
        after_action :create_cache, only: [:index]

        # http://api.rubyonrails.org/classes/ActionController/ParamsWrapper.html
        wrap_parameters :core_user, include: [:id, :email, :username, :password, :confirmation_password, :firstname, :lastname]

        # swagger api docs
        swagger_controller :Users, 'Users'

        swagger_api :create do
            summary 'Create User and Generate Token'
            notes 'format is {
	                            "core_user": {
                                    "email": "[email]",
                                    "username": "[username]",
                                    "password": "[password]",
                                    "confirmation_password": "[confirmation_password]",
                                    "firstname": "[firstname]",
                                    "lastname": "[lastname]"
                    	        }
                             }'
            param :body, :core_user, :string, :required, 'core_user object'
        end
        def create
            user_form = Admin::UserForm.new(user_form_params)
            token, uid = admin_service.create_user(user_form)
            if token && uid
                render :json => { status: '200', message: 'Success', uid: uid, token: token }
            else
                render :json => { status: '404', message: 'Failed' }
            end
        end

        swagger_api :index do
            summary 'List of Users'
            notes 'Please provide Notes'
            param :header, :uid, :string, :required, 'UID'
            param :header, :Authorization, :string, :required, 'Bearer [Token]'
        end
        def index
            core_users = admin_service.find_users(params[:page])
            if core_users.size > 0
                render :json => core_users, root: 'results', each_serializer: Admin::CoreUserSerializer
            else
                render :json => { results: []}
            end
        end

        swagger_api :delete do
            summary 'Delete User'
            notes 'Please provide Notes'
            param :header, :uid, :string, :required, 'UID'
            param :header, :Authorization, :string, :required, 'Bearer [Token]'
            param :path, :id, :integer, :required, 'userId'
        end
        def delete
            if admin_service.delete_user(params[:id])
                render :json => { status: '200', message: 'Success' }
            else
                render :json => { status: '404', message: 'Failed' }
            end
        end

        swagger_api :edit do
            summary 'Edit User'
            notes 'Please provide Notes'
            param :header, :uid, :string, :required, 'UID'
            param :header, :Authorization, :string, :required, 'Bearer [Token]'
        end
        def edit
            id = params[:id]
            core_user = admin_service.find_user(id)

            # # change id as string not oid
            # core_user = core_user.as_json(:except => :_id).merge('id' => core_user.id.to_s)
            if core_user
                render :json => { status: '200', payload: core_user }
            else
                render :json => { status: '404', message: 'Failed' }
            end
        end

        swagger_api :update do
            summary 'Update User'
            notes 'format is {
	                            "core_user": {
                                    "id": "[UID]",
                                    "email": "[email]",
                                    "username": "[username]",
                                    "password": "[password]",
                                    "confirmation_password": "[confirmation_password]",
                                    "firstname": "[firstname]",
                                    "lastname": "[lastname]"
                    	        }
                             }'
            param :header, :uid, :string, :required, 'UID'
            param :header, :Authorization, :string, :required, 'Bearer [Token]'
            param :body, :core_user, :string, :required, 'core_user object'
        end
        def update
            user_form = Admin::UserForm.new(user_form_params)
            if admin_service.update_user(user_form)
                render :json => { status: '200', message: 'Update Success' }
            else
                render :json => { status: '404', message: 'Update Failed' }
            end
        end

        private
        # Using strong parameters
        def user_form_params
            params.require(:core_user).permit(:id, :email, :username, :password, :confirmation_password, :firstname, :lastname)
            # params.require(:core_user).permit! # allow all
        end
    end
end
