class MarkazunaGenerator < Rails::Generators::NamedBase
	source_root File.expand_path('templates', __dir__)

	class_option :service_name, type: :string, default: 'generic_service'
	class_option :fields, type: :array, default: '[:id]'

	def generate_controller_files
		@service_name = options['service_name']
		@fields = options['fields']
		if class_path[0].nil?
			@class_name = (class_path + [plural_name]).map!(&:camelize).join("::")
			template "controller.erb", File.join("app/controllers", "#{plural_file_name}_controller.rb")
		else
			@class_name = (class_path + [plural_name]).map!(&:camelize).join("::")
			template "controller.erb", File.join("app/controllers/#{class_path[0]}", "#{plural_file_name}_controller.rb")
		end
	end

	def generate_model_files
		@service_name = options['service_name']
		@fields = options['fields']
		if class_path[0].nil?
			template "model.erb", File.join("app/models", "#{file_name}.rb")
		else
			template "model.erb", File.join("app/models/#{class_path[0]}", "#{file_name}.rb")
		end
	end

	def generate_edit_response_files
		@fields = options['fields']
		if class_path[0].nil?
			template "edit_response.erb", File.join("app/models", "#{file_name}_edit_response.rb")
		else
			template "edit_response.erb", File.join("app/models/#{class_path[0]}", "#{file_name}_edit_response.rb")
		end
	end

	def generate_service_files
		@service_name = options['service_name']
		@fields = options['fields']
		if class_path[0].nil?
			template "service.erb", File.join("app/services", "#{file_name}_service.rb")
		else
			template "service.erb", File.join("app/services/#{class_path[0]}", "#{file_name}_service.rb")
		end
	end

	def generate_value_object_files
		@service_name = options['service_name']
		@fields = options['fields']
		if class_path[0].nil?
			template "value_object.erb", File.join("app/value_objects", "#{file_name}_form.rb")
		else
			template "value_object.erb", File.join("app/value_objects/#{class_path[0]}", "#{file_name}_form.rb")
		end
	end

	def generate_serializer_files
		@fields = options['fields']
		if class_path[0].nil?
			template "serializer.erb", File.join("app/serializers", "#{file_name}_serializer.rb")
		else
			template "serializer.erb", File.join("app/serializers/#{class_path[0]}", "#{file_name}_serializer.rb")
		end
	end

	def generate_other_files
		@service_name = options['service_name']
		@fields = options['fields']

		# routes
		if class_path[0].nil?
			insert_into_file 'config/routes.rb', before: /end\Z/ do <<-RUBY
	resources :#{plural_name}, controller: '#{plural_name}', only: [:index, :create, :update] do
		delete 'delete', on: :member
		get 'edit', on: :member
	end
			RUBY
			end
		else
			insert_into_file 'config/routes.rb', before: /end\Z/ do <<-RUBY
	scope :#{class_path[0]} do
		resources :#{plural_name}, controller: '#{class_path[0]}/#{plural_name}', only: [:index, :create, :update] do
			delete 'delete', on: :member
			get 'edit', on: :member
		end
	end
		RUBY
			end
		end

		# DI Container
		if class_path[0].nil?
			insert_into_file 'lib/markazuna/di_container.rb', after: "extend Dry::Container::Mixin\n" do <<-RUBY

		register :#{singular_name}_service do
			#{singular_name.capitalize}Service.new
		end
		RUBY
			end
		else
			insert_into_file 'lib/markazuna/di_container.rb', after: "extend Dry::Container::Mixin\n" do <<-RUBY

		register :#{singular_name}_service do
			#{class_path[0].capitalize}::#{singular_name.capitalize}Service.new
		end
		RUBY
			end
		end

		# apidocs controller
		if class_path[0].nil?
			insert_into_file 'app/controllers/apidocs_controller.rb', after: "require 'admin/core_user'\n" do <<-RUBY
require '#{plural_file_name}_controller'
require '#{file_name}'
			RUBY
			end
		else
			insert_into_file 'app/controllers/apidocs_controller.rb', after: "require 'admin/core_user'\n" do <<-RUBY
require '#{class_path[0]}/#{plural_file_name}_controller'
require '#{class_path[0]}/#{file_name}'
			RUBY
			end
		end

		insert_into_file 'app/controllers/apidocs_controller.rb', after: "SWAGGERED_CLASSES = [\n" do <<-RUBY
		#{@class_name}Controller,
		#{class_name},
		#{class_name}Form,
		#{class_name}EditResponse,
		RUBY
		end
    end
end