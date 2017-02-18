class SearchController < ApplicationController
  def index
    @search_results = KpccApiService.new(params).articles
  end
end
