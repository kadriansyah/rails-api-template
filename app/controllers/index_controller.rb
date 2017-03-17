class IndexController < ApplicationController
    before_action :authenticate, except: [:index]
    def index
        redirect_to '/api'
    end
end
