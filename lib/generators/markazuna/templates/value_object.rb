<%
    fields_accessor = ""
    for ii in 0..@fields.length-2 do
        fields_accessor = "#{fields_accessor}:#{@fields[ii]}, "
    end
    fields_accessor = "#{fields_accessor}:#{@fields[@fields.length-1]}"
    fields = ""
    for ii in 0..@fields.length-2 do
        next if @fields[ii] == 'id'
        fields = "#{fields}:#{@fields[ii]}, "
    end
    fields = "#{fields}:#{@fields[@fields.length-1]}"
    fields_self = ""
    for ii in 0..@fields.length-2 do
        next if @fields[ii] == 'id'
        fields_self = "#{fields_self}#{@fields[ii]}: self.#{@fields[ii]}, "
    end
    fields_self = "#{fields_self}#{@fields[@fields.length-1]}: self.#{@fields[@fields.length-1]}"
%>
class <%= class_name %>Form
    include ActiveModel::Model
    include Swagger::Blocks

    attr_accessor(<%= fields_accessor %>)

    # Validations
    <%
    @fields.each_with_index do |field, index|
        next if field == 'id'
    %>
    validates :<%= field %>, presence: true
    <%
    end
    %>

    swagger_schema '<%= class_name %>Form' do
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

    def save
        if valid?
            <%= singular_name %> = <%= class_name %>.new(<%= fields_self %>)
            <%= singular_name %>.save
            true
        else
            false
        end
    end

    def update
        if valid?
            <%= singular_name %> = <%= class_name %>.find(self.id)
            <%= singular_name %>.update_attributes!(<%= fields_self %>)
            true
        else
            false
        end
    end
end
