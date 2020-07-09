class UsersController < ApplicationController
  def new
    user = User.new(user_params)
    render json: {"username" => user.username, "email" => user.email}, status: 201
  end

  def index
    users = User.all
    render json: {resp: users}, status: 200
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def user_params
    params.permit(:username, :email, :password_digest, :first_name, :last_name, :street_address, :username, :street_address_2, :city, :state, :zipcode)
  end
end

