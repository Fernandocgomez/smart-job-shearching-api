class Api::UsersController < ApplicationController
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
    user = User.find_by_id(params[:id])
    if user
      user.update(user_params)
      if user.valid?
        render json: { "resp" => UserSerializer.new(user) }, status: 200
      else
        render json: { "resp" => user.errors.messages }, status: 400
      end
    else
      render json: { "resp" => "user can't be found" }, status: 404
    end
  end

  def destroy
    user = User.find_by_id(params[:id])
    if user
      user.destroy
      render json: { "resp" => "user has been deleted" }, status: 200
    else
      render json: { "resp" => "user can't be found" }, status: 404
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
