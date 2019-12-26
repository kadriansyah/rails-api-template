---
inject: true
to: app/controllers/<%= page_controller %>_controller.rb
after: "case params\\[:name\\]"
---
            ####### <%= h.inflection.transform(name, [ 'demodulize', 'underscore', 'pluralize' ]) %> #######
            when "<%= h.inflection.transform(name, [ 'demodulize', 'underscore', 'pluralize' ]) %>"
                render template: "<%= name.split('::').length > 1 ? h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, [ 'demodulize', 'underscore', 'pluralize' ]) : h.inflection.transform(name, [ 'demodulize', 'underscore', 'pluralize' ]) %>"

            when "<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>_new"
                render template: "<%= name.split('::').length > 1 ? h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, [ 'demodulize', 'underscore' ]) : h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>_form", :locals => { :_id => nil }
            
            when "<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>_edit"
                render template: "<%= name.split('::').length > 1 ? h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, [ 'demodulize', 'underscore' ]) : h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>_form", :locals => { :_id => params[:id], :_copy => 'false' }

            when "<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>_copy"
                render template: "<%= name.split('::').length > 1 ? h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, [ 'demodulize', 'underscore' ]) : h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>_form", :locals => { :_id => params[:id], :_copy => 'true' }
