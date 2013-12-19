require 'json'
require 'webrick'

class Session
  
  def initialize(request)
    request.cookies.each do |cookie|
      if cookie.name == "_rails_lite_app_session"
        @cookie = JSON.parse(cookie.value)
        @cookie = Hash[@cookie.map { |key, val| [key.to_sym, val] }]
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
  
  def clear_cookie
    @cookie = {}
  end
  
  def get_authenticity_token
    @cookie[:authenticity_token] ||= SecureRandom.urlsafe_base64(16)
  end

  def store_session(response)
    get_authenticity_token
    
    name = "_rails_lite_app_session"
    value = @cookie.to_json
    cookie = WEBrick::Cookie.new(name, value)
    
    response.cookies << cookie
  end
end
