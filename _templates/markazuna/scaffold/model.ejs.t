---
to: "<%= name.split('::').length > 1 ? 'app/models/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, ['demodulize','underscore']) +'.rb' : 'app/models/'+ h.inflection.transform(name, ['demodulize','underscore']) +'.rb' %>"
unless_exists: true
---
require 'bcrypt'
require 'swagger/blocks'
require 'markazuna/common_model'

class <%= name %>
	include BCrypt
    include Mongoid::Document
    include Swagger::Blocks
    include Markazuna::CommonModel
    store_in collection: '<%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>'

    swagger_schema '<%= name %>' do
        key :required, [<% fields.split(',').forEach(function(field,idx){%>:<%= field %><% if(idx < fields.split(',').length - 1) { %>, <% }}); %>]<% fields.split(',').slice(1, fields.split(',').length).forEach(function (field) { %>
        property :<%= field %> do
            key :type, :string
        end<% }); %>
    end

    # kaminari page setting
    paginates_per 20
	<% fields.split(',').slice(1, fields.split(',').length).forEach(function (field) { %>
    field :<%= field %>, type: String, default: ''<% }); %>
end