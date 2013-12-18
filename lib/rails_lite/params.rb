require 'uri'

class Params
  attr_reader :params
  
  def initialize(req, route_params)
    @params = route_params
    params_strings = [req.query_string, req.body].compact
    parse_www_encoded_form(params_strings)
  end

  def [](key)
  end

  def to_s
  end

  private
  
  def nested_hash(params)
    new_params = {}
    
    params.each do |key, value|
      levels = parse_key(key)
      hash = new_params

      levels.each do |level|
        if levels.last == level
          hash[level] = value
        end
  
        hash[level] ||= {}
        hash = hash[level]
      end
    end
  
    new_params
  end
  
  def parse_www_encoded_form(strings)
    params = {}
    
    strings.each do |string|
      array = URI.decode_www_form(string)
      array.each do |pair|
        params[pair.first] = pair.last
      end
    end
    
    @params.merge(nested_hash(params))
          
    nil
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end







  
  
  
  