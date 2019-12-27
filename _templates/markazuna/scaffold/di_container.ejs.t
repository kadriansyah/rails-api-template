---
inject: true
to: lib/markazuna/di_container.rb
after: "extend Dry::Container::Mixin\n"
---
        register :<%= h.inflection.transform(service_name, ['demodulize','underscore']) %> do
            <%= service_name %>.new
        end
