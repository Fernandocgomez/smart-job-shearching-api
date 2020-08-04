class Api::UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def create
    user = User.new(user_params)
    if user.valid?
      user.save
      render json: { "resp" => UserSerializer.new(user) }, status: 201
    else
      render json: { "resp" => user.errors.messages }, status: 400
    end
  end

  def show
    user = User.find_by_id(params[:id])
    if user
      render json: { "resp" => UserSerializer.new(user) }, status: 200
    else
      render json: { "resp" => "user can't be found" }, status: 404
    end
  end

  def update
    if (params[:id].to_i == decoded_token[0]["user_id"])
      user = User.find_by_id(params[:id])
      user.update(user_params)
      if user.valid?
        render json: { "resp" => UserSerializer.new(user) }, status: 200
      else
        render json: { "resp" => user.errors.messages }, status: 400
      end
    else
      render json: {"resp" => "you need admin privileges to edit other users"}, status: 401
    end
  end

  def destroy
    if (params[:id].to_i == decoded_token[0]["user_id"])
      user = User.find_by_id(params[:id])
      user.destroy
      render json: { "resp" => "user has been deleted" }, status: 200
    else
      render json: {"resp" => "you need admin privileges to delete other users"}, status: 401
    end
  end

  private

  def user_params
    params.permit(
      :username,
      :email,
      :password,
      :password_confirmation,
      :first_name,
      :last_name,
      :city,
      :state,
      :zipcode
    )
  end
end
