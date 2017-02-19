class SearchController < ApplicationController
  def index
    begin
      @search_results = KpccApiService.new(params).articles
    rescue
      flash[:notice] = "Network error. Please try again in a few minutes."
      redirect_to root_path
    end
  end
end
