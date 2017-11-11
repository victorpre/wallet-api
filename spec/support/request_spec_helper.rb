module RequestSpecHelper
  def as_json(body)
    JSON.parse(body, symbolize_names: true)
  end
end
