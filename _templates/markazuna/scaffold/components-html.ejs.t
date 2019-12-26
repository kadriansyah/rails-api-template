---
to: "<%= name.split('::').length > 1 ? 'app/views/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.changeCase.paramCase(h.inflection.transform(name, ['demodulize','pluralize'])) +'.html.erb' : 'app/views/'+ h.changeCase.paramCase(h.inflection.transform(name, ['demodulize','pluralize'])) +'.html.erb' %>"
unless_exists: true
---
<%%= javascript_pack_tag "<%= name.split('::').length > 1 ? 'components/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.changeCase.paramCase(h.inflection.transform(name, ['demodulize','pluralize'])) : 'components/'+ h.changeCase.paramCase(h.inflection.transform(name, ['demodulize','pluralize'])) %>", defer: true %%>
<style>
    <%= h.changeCase.paramCase(h.inflection.demodulize(name)) %>-list {
        margin: 0;
    }
    .component_container {
        padding: 0;
    }
</style>
<div class="row">
    <div class="col-md-12 col-sm-12 col-xs-12 component_container">
        <<%= h.changeCase.paramCase(h.inflection.demodulize(name)) %>-list dataUrl="/<%= name.split('::').length > 1 ? h.changeCase.lower(name.split('::')[0]) +'/'+ h.changeCase.paramCase(h.inflection.transform(name, ['demodulize','pluralize'])) : h.changeCase.paramCase(h.inflection.transform(name, ['demodulize','pluralize'])) %>"></<%= h.changeCase.paramCase(h.inflection.demodulize(name)) %>-list>
    </div>
</div>
