require 'rails_helper'

RSpec.describe "Users", type: :request do
  context 'when sending a POST request to users/new using valid user params' do

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

    it "returns http 201 when a new instance is initiated" do

      post "/users/new", params: @user_valid_params

      expect(response).to have_http_status(201)

    end

    it "returns instance of User in JSON" do

      post "/users/new", params: @user_valid_params
      json = JSON.parse(response.body)

      expect(json['resp']).to match({
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


  context "When sending a GET request to users/index" do

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

  context "When sending a POST request to users/create with valid paramas" do

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

    it "returns a 201 http status" do
      post "/users/create", params: @user_valid_params
      expect(response).to have_http_status(201)
    end

    it "creates an instance of the User model and save it on the DB" do 
      db_size = User.all.size

      post "/users/create", params: @user_valid_params
      
      expect(User.all.size).to eql(db_size + 1)
    end

    it "returns an instance of the User model in JSON" do 
      post "/users/create", params: @user_valid_params
      json = JSON.parse(response.body)

      expect(json['resp']).to match({
        "id" => json['resp']['id'],
        "username" => "fernandocgomez", 
        "email" => "fernandocgomez@live.com",
      })
    end


  end

  context "When sending a GET request to users/show/:id" do
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

    it "returns http 200 if user lives on DB" do
      post "/users/create", params: @user_valid_params
      user_id = JSON.parse(response.body)['resp']['id']
      get "/users/show/#{user_id}"

      expect(response).to have_http_status(200)
    end

    it "return http 404 if user doesn't live on DB" do
      post "/users/create", params: @user_valid_params
      user_id = JSON.parse(response.body)['resp']['id']
      get "/users/show/#{user_id + 1}"
      expect(response).to have_http_status(404)
    end

    it "find and returns a specific instance of User model based on the id in JSON" do 
      post "/users/create", params: @user_valid_params
      user_id = JSON.parse(response.body)['resp']['id']
      get "/users/show/#{user_id}"

      json = JSON.parse(response.body)

      expect(json['resp']).to match({
        "id" => user_id,
        "username" => "fernandocgomez", 
        "email" => "fernandocgomez@live.com",
        "first_name" => "Fernando", 
        "last_name" => "Gomez", 
        "street_address" => "11900 City Park Central Ln", 
        "street_address_2" => "7210", 
        "city" => "Houston", 
        "state" => "Tx", 
        "zipcode" => 77047
      })
    end
  end

  context "When sending a PUT request to users/update/:id" do

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

      @user_changes = {
        first_name: "Cris", 
        last_name: "Cruz"
      }


    end

    it "returns a http 200 when a specific record gets updated" do

      post "/users/create", params: @user_valid_params
      temp_user = JSON.parse(response.body)
      put "/users/update/#{temp_user['resp']['id']}", params: @user_changes

      expect(response).to have_http_status(200)
    end

    it "return a http 400 when there is a bad request" do 
      # Wait for validations
      # post "/users/create", params: @user_valid_params
      # temp_user = JSON.parse(response.body)
      # put "/users/update/#{temp_user['resp']['id']}", params: @user_changes
      
      # expect(response).to have_http_status(400)
    end

    it "return the updated record in JSON" do 

      post "/users/create", params: @user_valid_params
      temp_user_created = JSON.parse(response.body)

      get "/users/show/#{temp_user_created['resp']['id']}"
      temp_user_found = JSON.parse(response.body)

      put "/users/update/#{temp_user_created['resp']['id']}", params: @user_changes
      json = JSON.parse(response.body)

      expect(json['resp']).to match({
        "id" => temp_user_found['resp']['id'],
        "username" => temp_user_found['resp']['username'], 
        "email" => temp_user_found['resp']['email'],
        "first_name" => @user_changes[:first_name], 
        "last_name" => @user_changes[:last_name], 
        "street_address" => temp_user_found['resp']['street_address'], 
        "street_address_2" => temp_user_found['resp']['street_address_2'], 
        "city" => temp_user_found['resp']['city'], 
        "state" => temp_user_found['resp']['state'], 
        "zipcode" => temp_user_found['resp']['zipcode']
      })
    end
  end

  context "When sending a DELETE request to users/destroy/:id" do
    before(:each) do
      user_valid_params = {
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
      post "/users/create", params: user_valid_params
      @temp_user_created = JSON.parse(response.body)
    end

    it "returns a http 200 when specific user gets deleted" do
      delete "/users/destroy/#{@temp_user_created['resp']['id']}"

      expect(response).to have_http_status(200)
    end

    it "returns a http 404 when the user is not found" do 
      delete "/users/destroy/#{@temp_user_created['resp']['id'] + 1}"

      expect(response).to have_http_status(404)
    end

    it "return a success message when the user is deleted" do
      delete "/users/destroy/#{@temp_user_created['resp']['id']}"
      json = JSON.parse(response.body)

      expect(json['resp']['message']).to match("User has been deleted")
    end

    it "return a fail message when the user isn't deleted" do
      delete "/users/destroy/#{@temp_user_created['resp']['id'] + 1}"
      json = JSON.parse(response.body)

      expect(json['resp']['message']).to match("User not found")
    end

  end

end
