class Api::AuthController < ApplicationController

  skip_before_action :authorized, only: [:login]

  def login
    user = User.find_by(username: params[:username])
    if user 
      if user.authenticate(params[:password])
        token = encode_token({user_id: user.id})
        render json: {"resp" => {"user" => UserSerializer.new(user), "token" => token}}, status: 200
      else
        render json: {"resp" => "invalid password"}, status: 401
      end
    else
      render json: {"resp" => "invalid username"}, status: 404
    end
  end

end
