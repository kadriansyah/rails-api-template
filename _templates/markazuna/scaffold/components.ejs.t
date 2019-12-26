---
to: "<%= name.split('::').length > 1 ? 'app/javascript/packs/components/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.changeCase.paramCase(h.inflection.transform(name, ['demodulize','pluralize'])) +'.js' : 'app/javascript/packs/components/'+ h.changeCase.paramCase(h.inflection.transform(name, ['demodulize','pluralize'])) +'.js' %>"
unless_exists: true
---
/*---------------------------------------------------------------------
  For oldie browser
  load webcomponents bundle, which includes all the necessary polyfills
----------------------------------------------------------------------*/
import '@webcomponents/webcomponentsjs/webcomponents-loader.js'

/*---------------------------------------------------------------------
  Import Components
----------------------------------------------------------------------*/
import './<%= h.changeCase.paramCase(h.inflection.demodulize(name)) %>-list.js'
import './<%= h.changeCase.paramCase(h.inflection.demodulize(name)) %>-form.js'