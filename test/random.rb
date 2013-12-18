params = {
  "cat[name]" => "leon",
  "cat[age]" => "7",
  "cat[owner][owner_name]" => "m",
  "cat[owner][owner_age]" => "30",
}

def nested_hash_test(params)
  new_params = {}
  params.each do |key, value|
    levels = key.split(/\]\[|\[|\]/)
    hash = new_params

    levels.each do |level|
      if levels.last == level
        hash[level] = value
      end
  
      hash[level] ||= {}
      hash = hash[level]
      p new_params
    end
  end
  
  new_params
end

nested_hash_test(params)