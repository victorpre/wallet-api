module RequestSpecHelper
  def as_json(body)
    JSON.parse(body, symbolize_names: true)
  end

  def valid_headers
    {
      'Authorization': "Token token=#{@user.auth_token}"
    }
  end
end
