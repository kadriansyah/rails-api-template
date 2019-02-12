require 'bcrypt'
require 'swagger/blocks'
require 'markazuna/common_model'
<%
    fields = ""
    for ii in 0..@fields.length-2 do
        next if @fields[ii] == 'id'
        fields = "#{fields}:#{@fields[ii]}, "
    end
    fields = "#{fields}:#{@fields[@fields.length-1]}"
%>
class <%= class_name %>
	include BCrypt
    include Mongoid::Document
    include Swagger::Blocks
    include Markazuna::CommonModel
    store_in collection: '<%= plural_name %>'

    swagger_schema '<%= class_name %>' do
        key :required, [<%= fields %>]
    <%
    @fields.each_with_index do |field, index|
        next if field == 'id'
    %>
        property :'<%= field %>' do
            key :type, :string
        end
    <%
    end
    %>
    end

    # kaminari page setting
    paginates_per 20
	<%
    @fields.each_with_index do |field, index|
        next if field == 'id'
    %>
    field :<%= field %>, type: String, default: ''
	<%
	end
	%>
end
