require 'erb'
require 'active_support/inflector'

module UrlHelper
  include ERB::Util
  
  def add_url_helper(action)
    resources = self.name.gsub("Controller", "").underscore
    define_method("#{action}_#{resources}_url") do
      host = self.request["Host"]
      "http://#{host}/#{resources}"
    end
    puts "Defined method: #{action}_#{resources}_url"
  end
  
end