require 'json'
require 'webrick'

class Session
  def initialize(request)
    request.cookies.each do |cookie|
      if cookie.name == "_rails_lite_app_session"
        @cookie = JSON.parse(cookie.value)
      end
    end
    
    @cookie ||= {}
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(response)
    name = "_rails_lite_app_session"
    value = @cookie.to_json
    cookie = WEBrick::Cookie.new(name, value)
    
    response.cookies << cookie
  end
end
