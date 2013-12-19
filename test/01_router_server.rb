require 'active_support/core_ext'
require 'json'
require 'webrick'
require_relative '../lib/rails_lite'

server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

class StatusesController < ControllerBase
  
  protect_from_forgery
  
  def index
    statuses = ["s1", "s2", "s3"]

    render_content(flash[:message], "text/text")
  end

  def show
    render_content(
      "status ##{params[:id]}, thing_id: #{params[:thing_id]}", "text/text"
    )
  end
  
  def new
    render :new
  end
end

class UsersController < ControllerBase
  def index
    users = ["u1", "u2", "u3"]

    render_content(users.to_json, "text/json")
  end
end

server.mount_proc '/' do |req, res|
  router = Router.new
  router.draw do
    get(
      Regexp.new("^/statuses\/(?<id>\\d+)\/thing\/(?<thing_id>\\d+)$"),
      StatusesController,
      :show)
    get Regexp.new("^/statuses/new$"), StatusesController, :new
    post Regexp.new("^/statuses"), StatusesController, :index
    get Regexp.new(""), StatusesController, :index
    get Regexp.new("^/users$"), UsersController, :index

    # uncomment this when you get to route params
#    get Regexp.new("^/statuses/(?<id>\\d+)$"), StatusController, :show
  end

  route = router.run(req, res)
end

server.start
