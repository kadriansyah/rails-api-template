---
to: "<%= name.split('::').length > 1 ? 'app/models/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, ['demodulize','underscore']) +'_edit_response.rb' : 'app/models/'+ h.inflection.transform(name, ['demodulize','underscore']) +'_edit_response.rb' %>"
unless_exists: true
---
class <%= name %>EditResponse
    include Swagger::Blocks

    swagger_schema '<%= name %>EditResponse' do
        key :required, [:status, :payload]
        property :status do
            key :type, :string
        end
        property :payload do
            key :'$ref', '<%= name %>'
        end
    end
end