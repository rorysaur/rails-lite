require 'webrick'
require 'json'

class Flash
  
  def initialize(request)
    request.cookies.each do |cookie|
      if cookie.name == "_rails_lite_app_flash"
        @old_flash = JSON.parse(cookie.value)
      end
    end
    
    @old_flash ||= {}
    @new_flash = {}
  end
    
  def [](key)
    @flash_now ? @old_flash[key] : @old_flash[key.to_s]
  end
  
  def []=(key, value)
    @new_flash[key] = value
  end
  
  def now
    @flash_now = true
    @old_flash
  end
  
  def store_flash(response)
    name = "_rails_lite_app_flash"
    value = @new_flash.to_json
    cookie = WEBrick::Cookie.new(name, value)
    
    response.cookies << cookie
  end
end