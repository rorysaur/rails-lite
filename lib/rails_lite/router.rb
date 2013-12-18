class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller, action)
    @routes << Route.new(pattern, method, controller, action)
  end

  def draw(&prc)
    self.instance_eval(&prc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller, action|
      add_route(pattern, http_method, controller, action)
    end
  end

  def match(req)    
    @routes.each do |route|
      return route if route.matches?(req)
    end
    
    nil
  end

  def run(req, res)
    route = match(req)
    
    if route
      route.run(req,res)
    else
      res.status = 404
    end
  end
end
