class ApplicationController < ActionController::API
  def encode_token(playload)
    JWT.encode(playload, "jobhunting", "HS256")
  end
end
