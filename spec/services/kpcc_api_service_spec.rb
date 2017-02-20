require "spec_helper"
require_relative "../../app/services/kpcc_api_service"

describe "Kpcc api service" do
  params = { search_term: "virgin galactic" }
  let!(:articles) { KpccApiService.new(params).articles}
  # TODO: Implement VCR gem to limit the number of requests when testing.

  it 'article search' do
    expect(articles.count).to eq 10
  end

  it 'redirects to the new search page if a connecting error is raised' do
    KpccApiService.new({}).stub(:articles) { raise "Faraday::ConnectionFailed" }

    expect {KpccApiService.new({}).articles }.not_to raise_error
  end
end

describe "Kpcc api service excerpt search" do
  let(:text) {"When I think about it, Virgin Galactic is the bomb."}
  let(:search_term) { "Virgin Galactic" }
  let(:text_search) { KpccApiService::Excerpt.new(search_term, text) }

  it 'finds the term in the body of the responses' do
    expect(text_search.search).to eq("I think about it, <strong>Virgin Galactic</strong>")
  end
end
