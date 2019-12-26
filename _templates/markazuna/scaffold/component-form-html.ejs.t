---
to: "<%= name.split('::').length > 1 ? 'app/views/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.changeCase.paramCase(h.inflection.demodulize(name))+'_form.html.erb' : 'app/views/'+ h.changeCase.paramCase(h.inflection.demodulize(name)) +'_form.html.erb' %>"
unless_exists: true
---
<%%= javascript_pack_tag "<%= name.split('::').length > 1 ? 'components/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.changeCase.paramCase(h.inflection.transform(name, ['demodulize','pluralize'])) : 'components/'+ h.changeCase.paramCase(h.inflection.transform(name, ['demodulize','pluralize'])) %>", defer: true %%>
<style>
    <%= h.changeCase.paramCase(h.inflection.demodulize(name)) %>-form {
        margin: 0;
    }
    .component_container {
        padding: 0;
    }
</style>
<div class="row">
    <div class="col-md-12 col-sm-12 col-xs-12 component_container">
        <%% if _id == nil then %%>
        <<%= h.changeCase.paramCase(h.inflection.demodulize(name)) %>-form actionUrl="/<%= name.split('::').length > 1 ? h.changeCase.lower(name.split('::')[0]) +'/'+ h.changeCase.paramCase(h.inflection.transform(name, ['demodulize','pluralize'])) : h.changeCase.paramCase(h.inflection.transform(name, ['demodulize','pluralize'])) %>" formAuthenticityToken="<%%= form_authenticity_token.to_s %%>"></<%= h.changeCase.paramCase(h.inflection.demodulize(name)) %>-form>
        <%% else %%>
        <<%= h.changeCase.paramCase(h.inflection.demodulize(name)) %>-form actionUrl="/<%= name.split('::').length > 1 ? h.changeCase.lower(name.split('::')[0]) +'/'+ h.changeCase.paramCase(h.inflection.transform(name, ['demodulize','pluralize'])) : h.changeCase.paramCase(h.inflection.transform(name, ['demodulize','pluralize'])) %>" objectId="<%%= _id %%>" copy="<%%= _copy %%>" formAuthenticityToken="<%%= form_authenticity_token.to_s %%>"></<%= h.changeCase.paramCase(h.inflection.demodulize(name)) %>-form>
        <%% end %%>
    </div>
</div>