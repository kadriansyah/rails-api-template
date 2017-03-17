class Swagger::Docs::Config
    def self.base_api_controller; ApplicationController end

    def self.transform_path(path, api_version)
        "apidocs/#{path}"
    end
end

Swagger::Docs::Config.register_apis({
                                        :'1.0' => {
                                            controller_base_path: '',
                                            # the extension used for the API
                                            :api_extension_type => :json,
                                            # the output location where your .json files are written to
                                            :api_file_path => 'public/apidocs',
                                            # the URL base path to your API
                                            :base_path => 'http://localhost:3000',
                                            # if you want to delete all .json files at each generation
                                            :clean_directory => false,
                                            # Ability to setup base controller for each api version. Api::V1::SomeController for example.
                                            :parent_controller => ApplicationController,
                                            # add custom attributes to api-docs
                                            :attributes => {
                                                :info => {
                                                    :title => 'MoslemCorners Base Framework API Documentation',
                                                    :description => 'Please provide the descriptions',
                                                    :termsOfServiceUrl => 'http://www.moslemcorners.com',
                                                    :contact => 'kadriansyah@gmail.com',
                                                    :license => 'Apache 2.0',
                                                    :licenseUrl => 'http://www.apache.org/licenses/LICENSE-2.0.html'
                                                }
                                            }
                                        }
                                    })
