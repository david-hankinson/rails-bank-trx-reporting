module Api
  class ReportController < ApplicationController
    def index
      report = Report.find_by(month: Date.parse(params[:month]))
  
      render json: report
    end
  
    def filter_params
      params.permit(:month)
    end
  end  
end