require 'net/http'
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
    params.has_key?("text")
  end

  def format_message(message)
    { text: message }.to_json
  end

  def find_gif
    url = URI.parse(' http://magictcgprices.appspot.com/api/images/imageurl.json?cardname=Pillar%20of%20Flame')
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    
    JSON.parse(res.body).text
    
  end

  def search_term
    params[:text].strip.downcase
  end

  def cache_buster
    @buster_string = "?buster=#{Random.rand(1..10000000000)}"
  end
end
