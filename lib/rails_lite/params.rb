require 'uri'

class Params
  
  def initialize(request, route_params)
    @params = route_params
    params_strings = [request.query_string, request.body].compact
    parse_www_encoded_form(params_strings)
    @params = Hash[@params.map { |key, val| [key.to_sym, val] }]
  end

  def [](key)
    @params[key]
  end
  
  def has_key?(key)
    @params.has_key?(key)
  end

  # def to_s
  # end

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
      
    @params.merge!(nested_hash(params))
          
    nil
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end







  
  
  
  