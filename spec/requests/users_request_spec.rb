require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "#create" do
    context "when request success" do
      let(:valid_params) { get_user_params("valid") }
      before(:each) do
        post "/api/users", params: valid_params
        @resp_json = JSON.parse(response.body)["resp"]
      end
      it "returns a 201 status" do
        expect(response).to have_http_status(201)
      end
      it "returns created user on JSON" do
        matcher = get_user_matcher(@resp_json["id"])

        expect(@resp_json).to match(matcher)
      end
      it "saves the user on the DB" do
        expect(User.count).to eq(1)
      end
    end
    context "when request fails" do
      let(:invalid_params) { get_user_params("invalid") }
      before(:each) do
        post "/api/users", params: invalid_params
        @resp_json = JSON.parse(response.body)["resp"]
      end
      it "returns a 400 status" do
        expect(response).to have_http_status(400)
      end
      it "returns an object of errors on JSON" do
        expect(@resp_json).to_not eq({})
      end
    end
  end
  describe "auth needed" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user, username: "cristobalgomez", email: "cristobal@live.com") }
    let(:token) { get_auth_token(user.id) }
    describe "#show" do
      context "when request success" do
        before(:each) do
          get "/api/user/#{user.id}", headers: token
          @resp_json = JSON.parse(response.body)["resp"]
        end
        it "returns a 200 status" do
          expect(response).to have_http_status(200)
        end
        it "returns user on JSON" do
          matcher = get_user_matcher(user.id)
          expect(@resp_json).to match(matcher)
        end
      end
      context "when request fails" do
        before(:each) do
          get "/api/user/#{user.id + 1}", headers: token
          @resp_json = JSON.parse(response.body)["resp"]
        end
        it "returns a 404 status" do
          expect(response).to have_http_status(404)
        end
        it "returns an error message on JSON" do
          expect(@resp_json).to match("user can't be found")
        end
      end
    end
    describe '#update' do
      context 'when request success' do
        before(:each) do
          @update_params = { "username" => "fernandocgomeztwo", "password" => "Ilovemytacos32%", "password_confirmation" => "Ilovemytacos32%" }
          put "/api/user/#{user.id}", params: @update_params, headers: token
          @resp_json = JSON.parse(response.body)["resp"]
        end
        it "returns a 200 status" do
          expect(response).to have_http_status(200)
        end
        it "returns updated user" do
          expect(@resp_json["username"]).to match(@update_params["username"])
        end
      end
      context 'when request fails because of invalid params' do
        before(:each) do
          @update_invalid_params = { "username" => nil, "password" => "Ilovemytacos32%", "password_confirmation" => "Ilovemytacos32%" }
          put "/api/user/#{user.id}", params: @update_invalid_params, headers: token
          @resp_json = JSON.parse(response.body)["resp"]
        end
        it "returns a 400 status" do
          expect(response).to have_http_status(400)
        end
        it "returns an object of errors on JSON" do
          expect(@resp_json["resp"]).to_not eq({})
        end
      end
      context 'when request fails because of unauthorized client' do
        before(:each) do
          @update_params = { "username" => "fernandocgomeztwo", "password" => "Ilovemytacos32%", "password_confirmation" => "Ilovemytacos32%" }
          put "/api/user/#{other_user.id}", params: @update_params, headers: token
          @resp_json = JSON.parse(response.body)["resp"]
        end
        it "returns a 401 status" do
          expect(response).to have_http_status(401)
        end
        it "returns an error message on JSON" do
          expect(@resp_json).to eq("you need admin privileges to edit other users")
        end
      end
    end
    describe '#destroy' do
      context 'request is successful' do
        before(:each) do
          delete "/api/user/#{user.id}", headers: token
          @resp_json = JSON.parse(response.body)["resp"]
        end
        it "returns a 200 status" do
          expect(response).to have_http_status(200)
        end
        it "returns a confirmation message on JSON" do
          expect(@resp_json).to eq("user has been deleted")
        end
      end
      context 'when request fails because of unauthorized client' do
        before(:each) do
          delete "/api/user/#{other_user.id}", headers: token
          @resp_json = JSON.parse(response.body)["resp"]
        end
        it "returns a 401 status" do
          expect(response).to have_http_status(401)
        end
        it "returns an error message on JSON" do
          expect(@resp_json).to eq("you need admin privileges to delete other users")
        end
      end
    end
  end
end