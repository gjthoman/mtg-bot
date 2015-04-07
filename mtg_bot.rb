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

    if params_present? && find_mtg_image
      format_message(find_mtg_image)
    else
      format_message("I couldn't find an image :cry:")
    end
  end

  def params_present?
    params.has_key?("text")
  end

  def format_message(message)
    { text: message }.to_json
  end

  def find_mtg_image

    url = URI.parse('http://magictcgprices.appspot.com/api/images/imageurl.json?cardname="' + search_term + '"')
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    
    mtg = JSON.parse(res.body)

    mtg[0]
    
  end

  def search_term
    params[:text]#.gsub(" ", "%20").strip.downcase
  end

  def cache_buster
    @buster_string = "?buster=#{Random.rand(1..10000000000)}"
  end
end
