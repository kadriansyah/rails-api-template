---
inject: true
to: app/controllers/apidocs_controller.rb
after: "SWAGGERED_CLASSES = \\["
---
        <%= name.split('::').length > 1 ? name.split('::')[0] +'::'+ h.inflection.transform(name, ['demodulize','pluralize']) : h.inflection.transform(name, ['demodulize','pluralize']) %>Controller,
        <%= name %>,
        <%= name %>Form,
        <%= name %>EditResponse,