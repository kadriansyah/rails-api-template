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
        swagger_controller :users, 'Users'

        swagger_api :create do
            summary 'Create User and Generate Token'
            notes 'Notes...'
            param :body, :core_user, :create_req_model, :required, 'core_user json object'
            response :ok, 'Success', :create_res_model
            response :unauthorized
            response :bad_request
        end
        swagger_model :create_req_model do
            description 'CoreUser Request Model Create'
            property :core_user, :core_user_model_create, :required, 'core_user_model'
        end
        swagger_model :core_user_model_create do
            description 'CoreUser Model Create'
            property :email, :string, :required, 'email'
            property :username, :string, :required, 'username'
            property :password, :string, :required, 'password'
            property :confirmation_password, :string, :required, 'confirmation_password'
            property :firstname, :string, :required, 'firstname'
            property :lastname, :string, :required, 'lastname'
        end
        swagger_model :create_res_model do
            description 'Create Response Model'
            property :status, :string, :required, 'Status Code'
            property :message, :string, :required, 'Message'
            property :uid, :string, :required, 'UID'
            property :token, :string, :required, 'Token'
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
            notes 'Notes...'
            param :header, :uid, :string, :required, 'UID'
            param :header, :Authorization, :string, :required, 'Bearer [Token]'
            response :ok, 'Success'
            response :unauthorized
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
            notes 'Notes...'
            param :header, :uid, :string, :required, 'UID'
            param :header, :Authorization, :string, :required, 'Bearer [Token]'
            param :path, :id, :integer, :required, 'userId'
            response :ok, 'Success'
            response :unauthorized
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
            notes 'Notes...'
            param :header, :uid, :string, :required, 'UID'
            param :header, :Authorization, :string, :required, 'Bearer [Token]'
            response :ok, 'Success'
            response :unauthorized
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
            notes 'Notes...'
            param :header, :uid, :string, :required, 'UID'
            param :header, :Authorization, :string, :required, 'Bearer [Token]'
            param :body, :core_user, :update_req_model, :required, 'core_user object'
            response :ok, 'Success'
            response :unauthorized
        end
        swagger_model :update_req_model do
            description 'CoreUser Request Model Update'
            property :core_user, :core_user_model_update, :required, 'core_user_model'
        end
        swagger_model :core_user_model_update do
            description 'CoreUser Model Update'
            property :id, :string, :required, 'id'
            property :email, :string, :required, 'email'
            property :username, :string, :required, 'username'
            property :password, :string, :required, 'password'
            property :confirmation_password, :string, :required, 'confirmation_password'
            property :firstname, :string, :required, 'firstname'
            property :lastname, :string, :required, 'lastname'
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
