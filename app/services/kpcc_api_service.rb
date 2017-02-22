require "faraday"
require "ostruct"
require "json"

class KpccApiService
  def initialize(params)
    @search_term = params[:search_term]
  end

  def articles
    articles_to_json.map do |a|
      serialize_articles a
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
      request.params["types"] = "news, blogs"
      # request.params["limit"] = 40
      # request.params["page"] = 4
    end
  end

  def article_audio(article)
    article["audio"][0] ? { audio_url: article["audio"][0]["url"] } : {}
  end

  def articles_to_json
    JSON.parse(kpcc_article_search.body)["articles"]
  end

  def serialize_articles article
    OpenStruct.new(
      {
        id: article["id"],
        title: article["title"],
        url: article["url"],
        excerpt: excerpt(article["body"]) || ""
      }
        .merge(article_audio(article)))
  end

  def excerpt body
    KpccApiService::Excerpt.new(search_term, body).search
  end
end

class KpccApiService::Excerpt
  attr_reader :target, :text

  def initialize(target, text)
    @target = target || ""
    @text = text
  end

  def search
    return format_both if format_both
    return format_right if format_right
    return format_left if format_left
  end

  def format_both
    a = text.scan(/(#{"\\S+ "*4})(#{Regexp.escape(target)})(#{" \\S+"*8})/i)
    a
      .flatten
      .insert(1, "<strong>")
      .insert(3, "</strong>")
      .join if a.any?
  end

  def format_left
    a = text.scan(/(#{"\\S+ "*4})(#{Regexp.escape(target)})/i)
    a
      .flatten
      .push("</strong>")
      .insert(1, "<strong>")
      .join if a.any?
  end

  def format_right
    a = text.scan(/(#{Regexp.escape(target)})(#{" \\S+"*8})/i)
    a
      .flatten
      .unshift("<strong>")
      .insert(2, "</strong>")
      .join if a.any?
  end
end
