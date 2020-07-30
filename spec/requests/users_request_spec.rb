require "rails_helper"

RSpec.describe "Users", type: :request do
  before(:each) do
    # get_user_params return and object with the defaul test data to create a user
    # requests_helper.rb
    @params = get_user_params
    @matcher = get_user_matcher
    @invalid_params = get_user_invalid_params(nil)
  end

  describe "POST /users" do
    context "request is successful" do
      it "returns a 201 status" do
        post "/users", params: @params
        expect(response).to have_http_status(201)
      end
      it "returns an instance of the User model on JSON" do
        post "/users", params: @params
        resp_json = JSON.parse(response.body)
        @matcher["id"] = resp_json["resp"]["id"]

        expect(resp_json["resp"]).to match(@matcher)
      end
      it "saves the user on the DB" do
        db_size = User.all.size
        post "/users", params: @params
        expect(User.all.size).to eq(db_size + 1)
      end
    end
    context "request fails" do
      it "returns a 400 status" do
        post "/users", params: @invalid_params
        expect(response).to have_http_status(400)
      end
      it "returns an object of errors on JSON" do
        post "/users", params: @invalid_params
        resp_json = JSON.parse(response.body)
        expect(resp_json["resp"]).to_not eq({})
      end
    end
  end

  describe "GET /user/:id" do
    before(:each) do
      post "/users", params: @params
      @params = JSON.parse(response.body)
    end
    context "request is successful" do
      it "returns a 200 status" do
        get "/user/#{@params["resp"]["id"]}"

        expect(response).to have_http_status(200)
      end
      it "returns an instance of the User model on JSON based on the id provided" do
        get "/user/#{@params["resp"]["id"]}"
        resp_json = JSON.parse(response.body)
        expect(resp_json["resp"]).to match(@params["resp"])
      end
    end
    context "request fails" do
      it "returns a 404 status" do
        get "/user/#{@params["resp"]["id"] + 1}"

        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        get "/user/#{@params["resp"]["id"] + 1}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to match("user can't be found")
      end
    end
  end
  describe "PUT /user/:id" do
    before(:each) do
      post "/users", params: @params
      @params = JSON.parse(response.body)
      @update_params = { "username" => "Cristobal", "password_digest_confirmation" => "Ilovemytacos32%" }
      @update_invalid_params = { "username" => nil, "password_digest_confirmation" => "Ilovemytacos32%" }
    end
    context "request is successful" do
      it "returns a 200 status" do
        put "/user/#{@params["resp"]["id"]}", params: @update_params

        expect(response).to have_http_status(200)
      end
      it "returns the updated instance of the User model on JSON" do
        put "/user/#{@params["resp"]["id"]}", params: @update_params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]["username"]).to match(@update_params["username"])
      end
    end
    context "request fails(invalid paramas)" do
      it "returns a 400 status" do
        put "/user/#{@params["resp"]["id"]}", params: @update_invalid_params

        expect(response).to have_http_status(400)
      end
      it "returns an object of errors on JSON" do
        put "/user/#{@params["resp"]["id"]}", params: @update_invalid_params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to_not eq({})
      end
    end
    context "request fails(invalid id)" do
      it "returns a 404 status" do
        put "/user/#{@params["resp"]["id"] + 1}", params: @update_params

        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        put "/user/#{@params["resp"]["id"] + 1}", params: @update_params
        resp_json = JSON.parse(response.body)
        expect(resp_json["resp"]).to eq("user can't be found")
      end
    end
  end
  describe "DELETE /user/:id" do
    before(:each) do
      post "/users", params: @params
      @params = JSON.parse(response.body)
    end
    context "request is successful" do
      it "returns a 200 status" do
        delete "/user/#{@params["resp"]["id"]}"

        expect(response).to have_http_status(200)
      end
      it "returns a confirmation message on JSON" do
        delete "/user/#{@params["resp"]["id"]}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("user has been deleted")
      end
      it "destroy record from the DB" do
        db_size = User.all.size
        delete "/user/#{@params["resp"]["id"]}"

        expect(User.all.size).to eq(db_size - 1)
      end
    end
    context "request fails" do
      it "returns a 404 status" do
        delete "/user/#{@params["resp"]["id"] + 1}"

        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        delete "/user/#{@params["resp"]["id"] + 1}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("user can't be found")
      end
    end
  end
end
