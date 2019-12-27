---
to: "<%= name.split('::').length > 1 ? 'app/controllers/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, ['demodulize','underscore','pluralize']) +'_controller.rb' : 'app/controllers/'+ h.inflection.transform(name, ['demodulize','underscore','pluralize']) +'_controller.rb' %>"
unless_exists: true
---
require 'markazuna/api_cache'
require 'markazuna/di_container'

class <%= name.split('::').length > 1 ? name.split('::')[0] +'::'+ h.inflection.transform(name, ['demodulize','pluralize']) : h.inflection.transform(name, ['demodulize','pluralize']) %>Controller < ApplicationController
    include Markazuna::APICache
    include Markazuna::INJECT[:<%= h.inflection.transform(service_name, ['demodulize','underscore']) %>]

    before_action   :authenticate
    after_action    :create_cache, only: [:index]

    # http://api.rubyonrails.org/classes/ActionController/ParamsWrapper.html
    wrap_parameters :<%= h.inflection.transform(name, ['demodulize','underscore']) %>, include: [<% fields.split(',').forEach(function(field,idx){%>:<%= field %><% if(idx < fields.split(',').length - 1) { %>, <% }}); %>]

    swagger_path '<%= name.split('::').length > 1 ? '/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, ['demodulize','underscore','pluralize']) : '/'+ h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>' do
        operation :get do
            key :summary, 'Please provide summary of this endpoint'
            key :description, 'Please provide description of this endpoint'
            key :operationId, 'find<%= h.inflection.transform(name, ['demodulize','pluralize']) %>'
            key :produces, [
                'application/json',
                'text/html',
            ]
            key :tags, [
                '<%= h.inflection.transform(name, ['demodulize','underscore']) %>'
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
                        key :'$ref', '<%= name %>'
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
        <%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>, page_count = <%= h.inflection.transform(service_name, ['demodulize','underscore']) %>.find_<%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>(params[:page])
        if (<%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>.size > 0)
            respond_to do |format|
                format.json { render :json => { results: <%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>, count: page_count }}
            end
        else
            render :json => { results: []}
        end
    end

    swagger_path '<%= name.split('::').length > 1 ? '/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, ['demodulize','underscore','pluralize']) +'/{id}/delete' : '/'+ h.inflection.transform(name, ['demodulize','underscore','pluralize']) +'/{id}/delete' %>' do
        operation :delete do
            key :summary, 'Please provide summary of this endpoint'
            key :description, 'Please provide description of this endpoint'
            key :operationId, 'delete<%= h.inflection.transform(name, ['demodulize','pluralize']) %>'
            key :produces, [
                'application/json',
                'text/html',
            ]
            key :tags, [
                '<%= h.inflection.transform(name, ['demodulize','underscore']) %>'
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
                key :description, 'Please provide description'
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
        status, page_count = <%= h.inflection.transform(service_name, ['demodulize','underscore']) %>.delete_<%= h.inflection.transform(name, ['demodulize','underscore']) %>(params[:id])
        if status
            respond_to do |format|
                format.json { render :json => { status: "200", count: page_count } }
            end
        else
            respond_to do |format|
                format.json { render :json => { status: "404", message: "Failed" } }
            end
        end
    end

    swagger_path '<%= name.split('::').length > 1 ? '/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, ['demodulize','underscore','pluralize']) : '/'+ h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>' do
        operation :post do
            key :summary, 'Please provide summary of this endpoint'
            key :description, 'Please provide description of this endpoint'
            key :operationId, 'add<%= h.inflection.demodulize(name) %>'
            key :produces, [
                'application/json'
            ]
            key :tags, [
                '<%= h.inflection.transform(name, ['demodulize','underscore']) %>'
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
                key :name, :<%= h.inflection.transform(name, ['demodulize','underscore']) %>
                key :in, :body
                key :description, 'Please provide description'
                key :required, true
                schema do
                    key :'$ref', '<%= name %>Form'
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
    def create
        <%= h.inflection.transform(name, ['demodulize','underscore']) %>_form = <%= name %>Form.new(<%= h.inflection.transform(name, ['demodulize','underscore']) %>_form_params)
        if <%= h.inflection.transform(service_name, ['demodulize','underscore']) %>.create_<%= h.inflection.transform(name, ['demodulize','underscore']) %>(<%= h.inflection.transform(name, ['demodulize','underscore']) %>_form)
            respond_to do |format|
                format.json { render :json => { status: "200", message: "Success" } }
            end
        else
            respond_to do |format|
                format.json { render :json => { status: "404", message: "Failed" } }
            end
        end
    end

    swagger_path '<%= name.split('::').length > 1 ? '/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, ['demodulize','underscore','pluralize']) +'/{id}/edit' : '/'+ h.inflection.transform(name, ['demodulize','underscore','pluralize']) +'/{id}/edit' %>' do
        operation :get do
            key :summary, 'Please provide summary of this endpoint'
            key :description, 'Please provide description of this endpoint'
            key :operationId, 'edit<%= h.inflection.demodulize(name) %>'
            key :produces, [
                'application/json',
                'text/html',
            ]
            key :tags, [
                '<%= h.inflection.transform(name, ['demodulize','underscore']) %>'
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
                key :description, 'Please provide description'
                key :required, true
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
    def edit
        id = params[:id]
        <%= h.inflection.transform(name, ['demodulize','underscore']) %> = <%= h.inflection.transform(service_name, ['demodulize','underscore']) %>.find_<%= h.inflection.transform(name, ['demodulize','underscore']) %>(id)
        if <%= h.inflection.transform(name, ['demodulize','underscore']) %>
            respond_to do |format|
                format.json { render :json => { status: "200", payload: <%= h.inflection.transform(name, ['demodulize','underscore']) %> } }
            end
        else
            respond_to do |format|
                format.json { render :json => { status: "404", message: "Failed" } }
            end
        end
    end

    swagger_path '<%= name.split('::').length > 1 ? '/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, ['demodulize','underscore','pluralize']) +'/{id}' : '/'+ h.inflection.transform(name, ['demodulize','underscore','pluralize']) +'/{id}' %>' do
        operation :put do
            key :summary, 'Please provide summary of this endpoint'
            key :description, 'Please provide description of this endpoint'
            key :operationId, 'update<%= h.inflection.demodulize(name) %>'
            key :produces, [
                'application/json',
                'text/html',
            ]
            key :tags, [
                '<%= h.inflection.transform(name, ['demodulize','underscore']) %>'
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
                key :description, 'Please provide description'
                key :required, true
            end
            parameter do
                key :name, :'<%= h.inflection.transform(name, ['demodulize','underscore']) %>'
                key :in, :body
                key :description, 'Please provide description'
                key :required, true
                schema do
                    key :'$ref', '<%= name %>Form'
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
        <%= h.inflection.transform(name, ['demodulize','underscore']) %>_form = <%= name %>Form.new(<%= h.inflection.transform(name, ['demodulize','underscore']) %>_form_params)
        <%= h.inflection.transform(name, ['demodulize','underscore']) %>_form.id = params[:id]
        if <%= h.inflection.transform(service_name, ['demodulize','underscore']) %>.update_<%= h.inflection.transform(name, ['demodulize','underscore']) %>(<%= h.inflection.transform(name, ['demodulize','underscore']) %>_form)
            respond_to do |format|
                format.json { render :json => { status: "200", message: "Success" } }
            end
        else
            respond_to do |format|
                format.json { render :json => { status: "404", message: "Failed" } }
            end
        end
    end

    private

    # Using strong parameters
    def <%= h.inflection.transform(name, ['demodulize','underscore']) %>_form_params
        params.require(:<%= h.inflection.transform(name, ['demodulize','underscore']) %>).permit(<% fields.split(',').forEach(function(field,idx){%>:<%= field %><% if(idx < fields.split(',').length - 1) { %>, <% }}); %>)
    end
end