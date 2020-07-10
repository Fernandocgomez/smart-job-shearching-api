class UsersController < ApplicationController
  def new
    user = User.new(user_params)
    render json: {"resp" => {"username" => user.username, "email" => user.email}}, status: 201
  end

  def index
    users = User.all
    render json: {resp: users}, status: 200
  end

  def create
    user = User.create(user_params)
    render json: {"resp" => {"id" => user.id, "username" => user.username, "email" => user.email}}, status: 201
  end

  def show
    user = User.find_by_id(params[:id])
    if user 
      render json: {"resp" => {
        "id" => user.id,
        "username" => user.username, 
        "email" => user.email,
        "first_name" => user.first_name, 
        "last_name" => user.last_name, 
        "street_address" => user.street_address, 
        "street_address_2" => user.street_address_2, 
        "city" => user.city, 
        "state" => user.state, 
        "zipcode" => user.zipcode
      }}, status: 200
    else 
      render status: 404
    end
  end

  def update
    user = User.find_by_id(params[:id])
    user.update(user_params)
    render json: {'resp' => {
      "id" => user.id,
      "username" => user.username, 
      "email" => user.email,
      "first_name" => user.first_name, 
      "last_name" => user.last_name, 
      "street_address" => user.street_address, 
      "street_address_2" => user.street_address_2, 
      "city" => user.city, 
      "state" => user.state, 
      "zipcode" => user.zipcode
    }}, status: 200
  end

  def destroy
    user = User.find_by_id(params[:id])
    if user 
      user.destroy
      render json: {'resp' => {'message' => "User has been deleted"}}, status: 200
    else 
      render json: {'resp' => {'message' => "User not found"}}, status: 404
    end
  end

  private

  def user_params
    params.permit(:username, :email, :password_digest, :first_name, :last_name, :street_address, :username, :street_address_2, :city, :state, :zipcode)
  end
end

