require 'markazuna/api_cache'
require 'markazuna/di_container'

module Admin
    class UsersController < ApplicationController
        include Markazuna::APICache
        include Markazuna::INJECT[:admin_service]

        before_action :authenticate, except: [:create]
        after_action :create_cache, only: [:index]

        # http://api.rubyonrails.org/classes/ActionController/ParamsWrapper.html
        wrap_parameters :core_user, include: [:id, :email, :username, :password, :confirmation_password, :firstname, :lastname]

        # swagger api docs
        swagger_path '/admin/users' do
            operation :post do
                key :summary, 'Create User and Generate Token'
                key :description, 'Create User and Generate Token'
                key :operationId, 'addCoreUser'
                key :produces, [
                    'application/json'
                ]
                key :tags, [
                    'core_user'
                ]
                parameter do
                    key :name, :core_user
                    key :in, :body
                    key :description, 'User to add'
                    key :required, true
                    schema do
                        key :'$ref', 'Admin::UserForm'
                    end
                end
                response 200 do
                    key :description, 'Success Response'
                    schema do
                        key :'$ref', 'Admin::CoreUserCreateResponse'
                    end
                end
                response :default do
                    key :description, 'unexpected error'
                    schema do
                        key :'$ref', 'Common::Response'
                    end
                end
            end
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

        swagger_path '/admin/users' do
            operation :get do
                key :summary, 'All Users'
                key :description, 'Returns all users from the system that the user has access to'
                key :operationId, 'findCoreUsers'
                key :produces, [
                    'application/json',
                    'text/html',
                ]
                key :tags, [
                    'core_user'
                ]
                parameter do
                    key :name, :uid
                    key :in, :header
                    key :description, 'UID'
                    key :required, true
                end
                parameter do
                    key :name, :authorization
                    key :in, :header
                    key :description, 'Bearer [Token]'
                    key :required, true
                end
                response 200 do
                    key :description, 'Success Response'
                    schema do
                        key :type, :array
                        items do
                            key :'$ref', 'Admin::CoreUser'
                        end
                    end
                end
                response :default do
                    key :description, 'unexpected error'
                    schema do
                        key :'$ref', 'Common::Response'
                    end
                end
            end
        end
        def index
            core_users = admin_service.find_users(params[:page])
            if core_users.size > 0
                render :json => core_users, root: 'results', each_serializer: Admin::CoreUserSerializer
            else
                render :json => { results: []}
            end
        end

        swagger_path '/admin/users/{id}/delete' do
            operation :delete do
                key :summary, 'Delete User'
                key :description, 'Delete user with certain id'
                key :operationId, 'deleteCoreUsers'
                key :produces, [
                    'application/json',
                    'text/html',
                ]
                key :tags, [
                    'core_user'
                ]
                parameter do
                    key :name, :uid
                    key :in, :header
                    key :description, 'UID'
                    key :required, true
                end
                parameter do
                    key :name, :authorization
                    key :in, :header
                    key :description, 'Bearer [Token]'
                    key :required, true
                end
                parameter do
                    key :name, :id
                    key :in, :path
                    key :description, 'User ID'
                    key :required, true
                end
                response 200 do
                    key :description, 'Success Response'
                end
                response :default do
                    key :description, 'unexpected error'
                    schema do
                        key :'$ref', 'Common::Response'
                    end
                end
            end
        end
        def delete
            if admin_service.delete_user(params[:id])
                render :json => { status: '200', message: 'Success' }
            else
                render :json => { status: '404', message: 'Failed' }
            end
        end

        swagger_path '/admin/users/{id}/edit' do
            operation :get do
                key :summary, 'Edit User'
                key :description, 'Edit user with certain id'
                key :operationId, 'editCoreUser'
                key :produces, [
                    'application/json',
                    'text/html',
                ]
                key :tags, [
                    'core_user'
                ]
                parameter do
                    key :name, :uid
                    key :in, :header
                    key :description, 'UID'
                    key :required, true
                end
                parameter do
                    key :name, :authorization
                    key :in, :header
                    key :description, 'Bearer [Token]'
                    key :required, true
                end
                parameter do
                    key :name, :id
                    key :in, :path
                    key :description, 'User ID'
                    key :required, true
                end
                response 200 do
                    key :description, 'Success Response'
                    schema do
                        key :'$ref', 'Admin::CoreUserEditResponse'
                    end
                end
                response :default do
                    key :description, 'unexpected error'
                    schema do
                        key :'$ref', 'Common::Response'
                    end
                end
            end
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

        swagger_path '/admin/users/{id}' do
            operation :put do
                key :summary, 'Update User'
                key :description, 'Update user with certain id'
                key :operationId, 'updateCoreUser'
                key :produces, [
                    'application/json',
                    'text/html',
                ]
                key :tags, [
                    'core_user'
                ]
                parameter do
                    key :name, :uid
                    key :in, :header
                    key :description, 'UID'
                    key :required, true
                end
                parameter do
                    key :name, :authorization
                    key :in, :header
                    key :description, 'Bearer [Token]'
                    key :required, true
                end
                parameter do
                    key :name, :id
                    key :in, :path
                    key :description, 'User ID'
                    key :required, true
                end
                parameter do
                    key :name, :core_user
                    key :in, :body
                    key :description, 'User to update'
                    key :required, true
                    schema do
                        key :'$ref', 'Admin::UserForm'
                    end
                end
                response 200 do
                    key :description, 'Success Response'
                    schema do
                        key :'$ref', 'Common::Response'
                    end
                end
                response :default do
                    key :description, 'unexpected error'
                    schema do
                        key :'$ref', 'Common::Response'
                    end
                end
            end
        end
        def update
            user_form = Admin::UserForm.new(user_form_params)
            user_form.id = params[:id]
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