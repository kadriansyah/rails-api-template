---
inject: true
to: config/routes.rb
after: "root to: 'index#index'"
---
	<% if (name.split('::').length > 1) { %>
	scope :<%= h.changeCase.lower(name.split('::')[0]) %> do
		resources :<%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>, controller: "<%= h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>", except: :destroy do
			get 'delete', on: :member
			get 'search', on: :collection
		end
	end
	<% } else { %>
	resources :<%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>, controller: "<%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>", except: :destroy do
		get 'delete', on: :member
		get 'search', on: :collection
	end
	<% } %>