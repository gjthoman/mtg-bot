require "sinatra/base"
require "json"

class MTGBot < Sinatra::Base
  @@gifs = {
    'amazed owl' => 'https://raw.githubusercontent.com/mohicanlove/reaction-gifs/master/amazed-owl.gif',
    'sheldon throwing papers' => 'https://raw.githubusercontent.com/mohicanlove/reaction-gifs/master/annoyed-sheldon-throwing-papers.gif'
  }

  post "/" do
    content_type :json

    if params_present? && find_gif
      format_message(find_gif)
    else
      format_message("I couldn't find a gif :cry:")
    end
  end

  def params_present?
    params.has_key?("text") && params.has_key?("trigger_word")
  end

  def format_message(message)
    { text: message }.to_json
  end

  def find_gif
    if @@gifs.key?(search_term)
      @random_gif = @@gifs[search_term] + cache_buster
    else
      false
    end
  end

  def search_term
    params[:text].gsub(params[:trigger_word], "").strip.downcase
  end

  def cache_buster
    @buster_string = "?buster=#{Random.rand(1..10000000000)}"
  end
end
