require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params, :flash, :request, :response
  
  include LinkHelper
  
  def self.protect_from_forgery
    define_method(:check_authenticity_token) do
      # puts "Params token: #{params[:authenticity_token]}"
      # puts "Session token: #{session[:authenticity_token]}"
      # p params.has_key?(:authenticity_token)
      # p params[:authenticity_token] == session[:authenticity_token]
      params.has_key?(:authenticity_token) && 
          params[:authenticity_token] == session[:authenticity_token]
    end
  end

  def initialize(request, response, route_params)
    @request = request
    @response = response
    @params = Params.new(request, route_params)
    @flash = Flash.new(request)
  end

  def session
    @session ||= Session.new(@request)
  end

  def already_rendered?
    @already_built_response
  end
  
  def controller_name
    self.class.to_s.underscore
  end
  
  def method_missing(method_name, obj = nil)
    action, resources, url = method_name.to_s.split("_")
    host = self.request["Host"]
    
    if %w(index create).include?(action)
      "http://#{host}/#{resources}"
    elsif action == "new"
      "http://#{host}/#{resources}/#{action}"
    elsif action == "edit"
      "http://#{host}/#{resources}/#{obj.id}/edit"
    elsif %w(show update destroy).include?(action)
      "http://#{host}/#{resources}/#{obj.id}"
    end
  end
  
  def prepare_response
    @already_built_response = true
    session.store_session(@response)
    flash.store_flash(@response)
  end

  def redirect_to(url)
    if already_rendered?
      raise "Double render error!"
    else
      @response.status = 302
      @response["Location"] = url
      prepare_response
    end
  end

  def render_content(content, type)
    if already_rendered?
      raise "Double render error!"
    else
      @response.content_type = type
      @response.body = content
      prepare_response
    end
  end

  def render(template_name)
    view_file = File.read(
      "views/#{controller_name}/#{template_name}.html.erb"
    )
    
    template = ERB.new(view_file)
    b = binding
    content = template.result(b)
    
    type = "text/html"
    
    render_content(content, type)
  end

  def invoke_action(name)    
    if @request.request_method != "GET" && 
        self.class.method_defined?(:check_authenticity_token)
      authenticated = check_authenticity_token
    else
      authenticated = true
    end
    
    if authenticated
      flash[:message] = "AUTHENTICATED!"
      self.send(name)
      render name unless @already_built_response
    else
      flash[:message] = "CHEAT0R!!"
      session.clear_cookie
      redirect_to "/"
    end
  end
end
