require "spec_helper"
require_relative "../../app/services/kpcc_api_service"

describe "Kpcc api service" do
  params = { search_term: "virgin galactic" }
  let!(:articles) { KpccApiService.new(params).articles}
  # TODO: Implement VCR gem to limit the number of requests when testing.

  it 'article search' do
    expect(articles.count).to eq 10
  end
end
