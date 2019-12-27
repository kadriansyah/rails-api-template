---
to: "<%= name.split('::').length > 1 ? 'app/value_objects/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, ['demodulize','underscore']) +'_form.rb' : 'app/value_objects/'+ h.inflection.transform(name, ['demodulize','underscore']) +'_form.rb' %>"
unless_exists: true
---
require 'swagger/blocks'

class <%= name %>Form
    include ActiveModel::Model
    include Swagger::Blocks

    attr_accessor(<% fields.split(',').forEach(function(field,idx){%>:<%= field %><% if(idx < fields.split(',').length - 1) { %>, <% }}); %>)
    <% fields.split(",").slice(1, fields.split(",").length).forEach(function (field) { %>
    validates :<%= field %>, presence: true<% }); %>

    swagger_schema '<%= name %>Form' do
        key :required, [<% fields.split(',').slice(1, fields.split(",").length).forEach(function(field,idx){%>:<%= field %><% if(idx < fields.split(',').length - 1) { %>, <% }}); %>]<% fields.split(',').slice(1, fields.split(',').length).forEach(function (field) { %>
        property :<%= field %> do
            key :type, :string
        end<% }); %>
    end

    def save
        if valid?
            <%= h.inflection.transform(name, ['demodulize','underscore']) %> = <%= name %>.new(<% fields.split(',').slice(1, fields.split(',').length).forEach(function(field,idx){%><%= field %>: self.<%= field %><% if(idx < fields.split(',').length - 2) { %>, <% }}); %>)
            <%= h.inflection.transform(name, ['demodulize','underscore']) %>.save
            true
        else
            false
        end
    end

    def update
        if valid?
            <%= h.inflection.transform(name, ['demodulize','underscore']) %> = <%= name %>.find(self.id)
            <%= h.inflection.transform(name, ['demodulize','underscore']) %>.update_attributes!(<% fields.split(',').slice(1, fields.split(',').length).forEach(function(field,idx){%><%= field %>: self.<%= field %><% if(idx < fields.split(',').length - 2) { %>, <% }}); %>)
            true
        else
            false
        end
    end
end