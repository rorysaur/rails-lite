require 'erb'

module LinkHelper
  include ERB::Util
  
  def link_to(label, url)
    "<a href=\"#{h(url)}\">#{h(label)}</a>"
  end
  
  def button_to(label, url, options = {})
    defaults = { :method => :get }
    
    options = defaults.merge(options)
    
    html = <<-HTML
    <form action="#{h(url)}" method="#{options[:method].to_s}">
      <input type="submit" value="#{h(label)}">
    </form>
    HTML
    
    html
  end
end