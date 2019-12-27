---
inject: true
to: config/routes.rb
after: "resources :apidocs, only: \\[:index\\]"
---
	<% if (name.split('::').length > 1) { %>
	scope :<%= h.changeCase.lower(name.split('::')[0]) %> do
		resources :<%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>, controller: "<%= h.changeCase.lower(name.split('::')[0]) +'/'+ h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>", only: [:index, :create, :update] do
			delete 'delete', on: :member
			get 'edit', on: :member
		end
	end
	<% } else { %>
	resources :<%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>, controller: "<%= h.inflection.transform(name, ['demodulize','underscore','pluralize']) %>", only: [:index, :create, :update] do
		delete 'delete', on: :member
		get 'edit', on: :member
	end
	<% } %>