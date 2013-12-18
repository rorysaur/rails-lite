class Route
  
  attr_reader :pattern, :method, :controller, :action
  
  def initialize(pattern, method, controller, action)
    @pattern, @method, @controller, @action =
      pattern, method, controller, action
  end
  
  def matches?(req)
    @pattern.match(req.path) && 
      @method == req.request_method.downcase.to_sym
  end
  
  def run(req, res)
    route_params = {}
    match_data = @pattern.match(req.path)
    
    @pattern.named_captures.each do |name, index|
      route_params[name.to_sym] = match_data[name]
    end
    
    @controller.new(req, res, route_params).invoke_action(@action)
  end
  
end