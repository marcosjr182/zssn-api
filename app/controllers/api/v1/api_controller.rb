module Api::V1
  class ApiController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

    private
    def record_not_found(error)
      render json: { error: error.message } , status: 403
    end
  end
end
