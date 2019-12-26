---
to: "<%= name.split('::').length > 1 ? 'app/controllers/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, ['demodulize','underscore','pluralize']) +'_controller.rb' : 'app/controllers/'+ h.inflection.transform(name, ['demodulize','underscore','pluralize']) +'_controller.rb' %>"
unless_exists: true
---
require_dependency 'markazuna/di_container'

class <%= name.split('::').length > 1 ? name.split('::')[0] +'::'+ h.inflection.transform(name, ['demodulize','pluralize']) : h.inflection.transform(name, ['demodulize','pluralize']) %>Controller < ApplicationController
    include Markazuna::INJECT["<%= h.inflection.transform(service_name, ['demodulize','underscore']) %>"]

    # http://api.rubyonrails.org/classes/ActionController/ParamsWrapper.html
    wrap_parameters :<%= h.inflection.transform(name, ['demodulize','underscore']) %>, include: [<% fields.split(',').forEach(function(field,idx){%>:<%= field %><% if(idx < fields.split(',').length - 1) { %>, <% }}); %>]

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

    def search
        <%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>, page_count = <%= h.inflection.transform(service_name, ['demodulize','underscore']) %>.find_<%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>_by_name(params[:name], params[:page])
        if (<%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>.size > 0)
            respond_to do |format|
                format.json { render :json => { results: <%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>, count: page_count }}
            end
        else
            render :json => { results: []}
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

    def update
        <%= h.inflection.transform(name, ['demodulize','underscore']) %>_form = <%= name %>Form.new(<%= h.inflection.transform(name, ['demodulize','underscore']) %>_form_params)
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