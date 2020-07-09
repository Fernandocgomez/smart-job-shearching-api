require 'rails_helper'

RSpec.describe "Users", type: :request do
  context 'when sending POST request to users/new using valid user params' do

    before(:each) do
      @user_valid_params = {
        username: "fernandocgomez", 
        email: "fernandocgomez@live.com", 
        password_digest: "password", 
        first_name: "Fernando", 
        last_name: "Gomez", 
        street_address: "11900 City Park Central Ln", 
        street_address_2: "7210", 
        city: "Houston", 
        state: "Tx", 
        zipcode: 77047
      }
    end

    it "returns http 201 when a new instance is created" do

      post "/users/new", params: @user_valid_params

      expect(response).to have_http_status(201)

    end

    it "returns instance of User in JSON" do

      post "/users/new", params: @user_valid_params
      json = JSON.parse(response.body)

      expect(json).to match({
        "username" => "fernandocgomez", 
        "email" => "fernandocgomez@live.com",
      })

    end

    it "creates an instance of User, but it doesn't save it on the DB" do

      db_size = User.all.size
      post "/users/new", params: @user_params

      expect(User.all.size).to eql(db_size)

    end

  end


  context "When sending GET request to users/index" do
    it "returns http 200 is request is succesful" do
      get "/users/index"
      expect(response).to have_http_status(200)
    end

    it "returns JSON data of all user on DB" do 
      get "/users/index"
      json = JSON.parse(response.body)

      expect(json['resp']).to match(User.all)
    end

  end

  # describe "GET /create" do
  #   it "returns http success" do
  #     get "/users/create"
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET /show" do
  #   it "returns http success" do
  #     get "/users/show"
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET /edit" do
  #   it "returns http success" do
  #     get "/users/edit"
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET /update" do
  #   it "returns http success" do
  #     get "/users/update"
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET /destroy" do
  #   it "returns http success" do
  #     get "/users/destroy"
  #     expect(response).to have_http_status(:success)
  #   end
  # end

end
