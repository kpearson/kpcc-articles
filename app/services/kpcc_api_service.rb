require "faraday"
require "ostruct"
require "json"

class KpccApiService

  def initialize(params)
    @search_term = params[:search_term]
  end

  def articles
    articles_to_json.map do |a|
      OpenStruct.new({ id: a["id"], title: a["title"] }.merge(article_audio(a)))
    end
  end

  private

  attr_reader :search_term

  def connection
    Faraday.new(url: "http://www.scpr.org")
  end

  def kpcc_article_search
      connection.get do |request|
      request.url "/api/v3/articles", :query => search_term
      request.params["types"] = ["news", "blogs", "segments", "shells"]
      #TODO param types is not formatting correctly. Seems to be working for now.
    end
  end

  def article_audio(article)
    article["audio"][0] ? { audio_url: article["audio"][0]["url"] } : {}
  end

  def articles_to_json
    JSON.parse(kpcc_article_search.body)["articles"]
  end
end
