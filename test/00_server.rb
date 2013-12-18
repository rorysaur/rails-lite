require 'active_support/core_ext'
require 'webrick'
require_relative '../lib/rails_lite'


server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

class MyController < ControllerBase
  def go
    # render_content("<h1>hello world!</h1>", "text/html")

    # after you have template rendering, uncomment:
   # render :show

    # after you have sessions going, uncomment:
   session["count"] ||= 0
   session["count"] += 1
   render :counting_show
  end
  
end

server.mount_proc '/users/' do |req, res|
  # c = MyController.new(req, res).go
  res.content_type = "text/text"
  res.body = req.path
end

server.start
