json.errors errors.keys do |key|
    json.name key
    json.errors errors[key]
end
