require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params, :flash

  def initialize(request, response, route_params)
    @request = request
    @response = response
    @params = Params.new(request, route_params).params
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
    self.send(name)
    render name unless @already_built_response
  end
end
