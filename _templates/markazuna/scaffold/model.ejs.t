---
to: "<%= name.split('::').length > 1 ? 'app/models/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, ['demodulize','underscore']) +'.rb' : 'app/models/'+ h.inflection.transform(name, ['demodulize','underscore']) +'.rb' %>"
unless_exists: true
---
require 'markazuna/common_model'

class <%= name %>
	include Mongoid::Document
    include Markazuna::CommonModel
    store_in collection: "<%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>"

    # kaminari page setting
    paginates_per 20
	<% fields.split(',').slice(1, fields.split(',').length).forEach(function (field) { %>
    field :<%= field %>, type: String, default: ''<% }); %>
end