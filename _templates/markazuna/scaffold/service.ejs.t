---
to: "<%= service_name.split('::').length > 1 ? 'app/services/'+ h.changeCase.lower(service_name.split('::')[0]) +'/'+ h.inflection.transform(service_name, ['demodulize','underscore']) +'.rb' : 'app/services/'+ h.inflection.transform(service_name, ['demodulize','underscore']) +'.rb' %>"
unless_exists: true
---
class <%= service_name %>
    def create_<%= h.inflection.transform(name, ['demodulize','underscore']) %>(<%= h.inflection.transform(name, ['demodulize','underscore']) %>_form)
        <%= h.inflection.transform(name, ['demodulize','underscore']) %>_form.save
    end

    def update_<%= h.inflection.transform(name, ['demodulize','underscore']) %>(<%= h.inflection.transform(name, ['demodulize','underscore']) %>_form)
        <%= h.inflection.transform(name, ['demodulize','underscore']) %>_form.update
    end

    def delete_<%= h.inflection.transform(name, ['demodulize','underscore']) %>(id)
        <%= h.inflection.transform(name, ['demodulize','underscore']) %> = find_<%= h.inflection.transform(name, ['demodulize','underscore']) %>(id)
        return <%= h.inflection.transform(name, ['demodulize','underscore']) %>.delete, <%= name %>.page(1).total_pages
    end

    def find_<%= h.inflection.transform(name, ['demodulize','underscore']) %>(id)
        <%= name %>.find(id)
    end

    def find_<%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>_by_<%= fields.split(',')[1] %>(<%= fields.split(',')[1] %>, page = 0)
        return <%= name %>.where(<%= fields.split(',')[1] %>: <%= fields.split(',')[1] %>).page(page), <%= name %>.page(1).total_pages
    end

    def find_<%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>(page = 0)
        return <%= name %>.page(page), <%= name %>.page(1).total_pages
    end
end