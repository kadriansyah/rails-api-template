---
inject: true
to: app/controllers/apidocs_controller.rb
after: "require 'admin/core_user'\n"
---
require '<%= name.split('::').length > 1 ? h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, ['demodulize','underscore','pluralize']) +'_controller.rb' : h.inflection.transform(name, ['demodulize','underscore','pluralize']) +'_controller.rb' %>'
require '<%= name.split('::').length > 1 ? h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, ['demodulize','underscore']) : h.inflection.transform(name, ['demodulize','underscore']) %>'
