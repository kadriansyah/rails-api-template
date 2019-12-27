---
to: "<%= name.split('::').length > 1 ? 'app/serializers/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, ['demodulize','underscore']) +'_serializer.rb' : 'app/serializers/'+ h.inflection.transform(name, ['demodulize','underscore']) +'_serializer.rb' %>"
unless_exists: true
---
class <%= name %>Serializer < ActiveModel::Serializer
    attributes <% fields.split(',').forEach(function(field,idx){%>:<%= field %><% if(idx < fields.split(',').length - 1) { %>, <% }}); %>

    attribute :id do
        object.id.to_s
    end
end