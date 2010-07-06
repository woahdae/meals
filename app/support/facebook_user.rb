class FacebookUser
  def initialize
    @app_id      = FB_CONFIG[:app_id]
    @api_key     = FB_CONFIG[:api_key]
    @secret      = FB_CONFIG[:secret]
    @redirect_to = FB_CONFIG[:redirect_to]
  end

  # First, a user needs to click on this
  def auth_url
    MiniFB.oauth_url(@app_id, @redirect_to,
      :scope => 'user_about_me') # See MiniFB.scopes
  end

  # facebook gives us the temporary code after the user authorizes us
  def user_from_code(temp_code)
    MiniFB.get(access_token(temp_code), "me")
  end

  private
    def access_token(temp_code)
      MiniFB.oauth_access_token(@app_id, @redirect_to, @secret, 
        temp_code)["access_token"]
    end
  # /private
end