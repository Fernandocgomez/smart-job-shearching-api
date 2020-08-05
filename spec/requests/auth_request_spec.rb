require "rails_helper"

RSpec.describe "Auths", type: :request do
  describe "#login" do
    before(:all) do
      @user = create(:user)
    end
    let(:params) { { "username" => "fernandocgomez", "password" => "Ilovemytacos32%" } }
    let(:wrong_username_params) { { "username" => "wronguser", "password" => "Ilovemytacos32%" } }
    let(:wrong_password_params) { { "username" => "fernandocgomez", "password" => "Ilovemytacos31%" } }
    context "when request success" do
      before(:each) do
        post "/api/login", params: params
        @resp_json = JSON(response.body)["resp"]
      end
      it "returns a 200 status" do
        expect(response).to have_http_status(200)
      end
      it "returns user and token on JSON" do
        matcher = get_user_matcher(@user.id)
        token = get_auth_token(@user.id)

        expect(@resp_json).to match({ "user" => matcher, "token" => token["Authorization"].split(" ")[1] })
      end
    end
    context "when request fails becuase of wrong username" do
      before(:each) do
        post "/api/login", params: wrong_username_params
        @resp_json = JSON(response.body)["resp"]
      end
      it "returns a 404 status" do
        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("invalid username")
      end
    end
    context "when request fails becuase of wrong password" do
      before(:each) do
        post "/api/login", params: wrong_password_params
        @resp_json = JSON(response.body)["resp"]
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("invalid password")
      end
    end
  end
end
