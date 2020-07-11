require "rails_helper"

RSpec.describe "Users", type: :request do
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
      zipcode: 77047,
    }

    @user_invalid_params = {
      username: nil,
      email: "fernandocgomez@live.com",
      password_digest: "password",
      first_name: "Fernando",
      last_name: "Gomez",
      street_address: "11900 City Park Central Ln",
      street_address_2: "7210",
      city: "Houston",
      state: "Tx",
      zipcode: 77047,
    }

    @matcher_user_instance = {
      "id" => nil,
      "username" => @user_valid_params[:username],
      "email" => @user_valid_params[:email],
      "first_name" => @user_valid_params[:first_name],
      "last_name" => @user_valid_params[:last_name],
      "street_address" => @user_valid_params[:street_address],
      "street_address_2" => @user_valid_params[:street_address_2],
      "city" => @user_valid_params[:city],
      "state" => @user_valid_params[:state],
      "zipcode" => @user_valid_params[:zipcode],
    }
  end
  describe "when sending a POST request to users/new" do
    context "if request is successful" do
      it "returns http 201" do
        post "/users/new", params: @user_valid_params

        expect(response).to have_http_status(201)
      end

      it "creates an instance of User, but it doesn't save it on the DB" do
        db_size = User.all.size

        post "/users/new", params: @user_valid_params

        expect(User.all.size).to eql(db_size)
      end

      it "returns instance of User in JSON" do
        post "/users/new", params: @user_valid_params
        json = JSON.parse(response.body)

        expect(json["resp"]).to match(@matcher_user_instance)
      end
    end

    context "if request failed" do
      it "return http 400" do
        post "/users/new", params: @user_invalid_params

        expect(response).to have_http_status(400)
      end

      it "return an object pointing to an array of errors" do
        post "/users/new", params: @user_invalid_params
        json = JSON.parse(response.body)

        expect(json["resp"]["errors"]).to match({ "username" => ["can't be blank"] })
      end
    end
  end

  describe "When sending a GET request to users/index" do
    it "returns http 200 status if succesful" do
      get "/users"

      expect(response).to have_http_status(200)
    end

    it "returns JSON data of all user on DB" do
      get "/users"

      json = JSON.parse(response.body)

      expect(json["resp"]).to match(User.all)
    end
  end

  describe "When sending a POST request to users/create" do
    context "if request is valid" do
      it "returns a 201 http status" do
        post "/users", params: @user_valid_params
        expect(response).to have_http_status(201)
      end

      it "creates an instance of the User model and save it on the DB" do
        db_size = User.all.size

        post "/users", params: @user_valid_params

        expect(User.all.size).to eql(db_size + 1)
      end

      it "returns an instance of the User model in JSON" do
        post "/users", params: @user_valid_params
        json = JSON.parse(response.body)
        @matcher_user_instance["id"] = json["resp"]["id"]

        expect(json["resp"]).to match(@matcher_user_instance)
      end
    end

    context "if request is invalid" do
      it "return http 400" do
        post "/users", params: @user_invalid_params

        expect(response).to have_http_status(400)
      end

      it "doesn't add a new record to the DB" do
        db_size = User.all.size

        post "/users", params: @user_invalid_params

        expect(User.all.size).to eql(db_size)
      end

      it "return an object pointing to an array of errors" do
        post "/users", params: @user_invalid_params
        json = JSON.parse(response.body)

        expect(json["resp"]["errors"]).to match({ "username" => ["can't be blank"] })
      end
    end
  end

  describe "When sending a GET request to users/show/:id" do
    before(:each) do
      post "/users", params: @user_valid_params
      @user_id = JSON.parse(response.body)["resp"]["id"]
    end

    context "If user lives on the DB" do
      it "returns http 200" do
        get "/user/#{@user_id}"

        expect(response).to have_http_status(200)
      end

      it "returns instance of User model based on the id passed in JSON" do
        get "/user/#{@user_id}"

        json = JSON.parse(response.body)

        @matcher_user_instance["id"] = @user_id

        expect(json["resp"]).to match(@matcher_user_instance)
      end
    end

    context "User doesn't live on DB" do
      it "return http 404 if user doesn't live on DB" do
        get "/user/#{@user_id + 1}"
        expect(response).to have_http_status(404)
      end

      it "return an error message" do
        get "/user/#{@user_id + 1}"
        json = JSON.parse(response.body)

        expect(json["resp"]["message"]).to eq("User can't be found")
      end
    end
  end

  describe "When sending a PUT request to users/update/:id" do
    before(:each) do
      @user_changes = {
        first_name: "Cris",
        last_name: "Cruz",
      }

      @user_negative_changes = {
        username: nil,
      }
    end

    context "If request is succesful" do
      it "returns a http 200 when a specific record gets updated" do
        post "/users", params: @user_valid_params
        temp_user_created = JSON.parse(response.body)

        put "/user/#{temp_user_created["resp"]["id"]}", params: @user_changes

        expect(response).to have_http_status(200)
      end

      it "return the updated record in JSON" do
        post "/users", params: @user_valid_params
        temp_user_created = JSON.parse(response.body)

        put "/user/#{temp_user_created["resp"]["id"]}", params: @user_changes
        json = JSON.parse(response.body)

        @matcher_user_instance["first_name"] = @user_changes[:first_name]
        @matcher_user_instance["last_name"] = @user_changes[:last_name]
        @matcher_user_instance["id"] = temp_user_created["resp"]["id"]

        expect(json["resp"]).to match(@matcher_user_instance)
      end
    end

    context "If request fails" do
      it "return a http 404 when the user can be found" do
        post "/users", params: @user_valid_params
        temp_user = JSON.parse(response.body)
        put "/user/#{temp_user["resp"]["id"] + 1}", params: @user_changes

        expect(response).to have_http_status(404)
      end

      it "return a error message if user can't be found" do
        post "/users", params: @user_valid_params
        temp_user = JSON.parse(response.body)
        put "/user/#{temp_user["resp"]["id"] + 1}", params: @user_changes
        json = JSON.parse(response.body)

        expect(json["resp"]["message"]).to eq("User can't be found")
      end

      it "return a http 400 when there is a bad request ex. the updated records violated the user validations" do
        post "/users", params: @user_valid_params
        temp_user = JSON.parse(response.body)
        put "/user/#{temp_user["resp"]["id"]}", params: @user_negative_changes

        expect(response).to have_http_status(400)
      end

      it "return an object pointing to an array of errors" do
        post "/users", params: @user_valid_params
        temp_user = JSON.parse(response.body)
        put "/user/#{temp_user["resp"]["id"]}", params: @user_negative_changes
        json = JSON.parse(response.body)

        expect(json["resp"]["errors"]).to match({ "username" => ["can't be blank"] })
      end
    end
  end

  describe "When sending a DELETE request to users/destroy/:id" do
    before(:each) do
      post "/users", params: @user_valid_params
      @temp_user_created = JSON.parse(response.body)
    end

    context "If request is succesful" do
      it "returns a http 200 when specific user gets deleted" do
        delete "/user/#{@temp_user_created["resp"]["id"]}"

        expect(response).to have_http_status(200)
      end

      it "return a success message" do
        delete "/user/#{@temp_user_created["resp"]["id"]}"
        json = JSON.parse(response.body)

        expect(json["resp"]["message"]).to match("User has been deleted")
      end
    end

    context "If request fails" do
      it "returns a http 404" do
        delete "/user/#{@temp_user_created["resp"]["id"] + 1}"

        expect(response).to have_http_status(404)
      end

      it "return a fail message" do
        delete "/user/#{@temp_user_created["resp"]["id"] + 1}"
        json = JSON.parse(response.body)

        expect(json["resp"]["message"]).to match("User not found")
      end
    end
  end
end
