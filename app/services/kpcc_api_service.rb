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
        excerpt: excerpt(article["body"])
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
    fb = format_both
    fr = format_right
    if fb.length >= 18
      fb
    elsif fr.length >= 18
      fr
    else
      format_left
    end
  end

  def format_both
    text
      .scan(/(#{"\\S+ "*4})(#{Regexp.escape(target)})(#{" \\S+"*8})/i)
      .flatten
      .insert(1, "<strong>")
      .insert(3, "</strong>")
      .join
  end

  def format_left
    text
      .scan(/(#{"\\S+ "*4})(#{Regexp.escape(target)})/i)
      .flatten
      .push("</strong>")
      .insert(1, "<strong>")
      .join
  end

  def format_right
    text
      .scan(/(#{Regexp.escape(target)})(#{" \\S+"*8})/i)
      .flatten
      .unshift("<strong>")
      .insert(2, "</strong>")
      .join
  end
end
