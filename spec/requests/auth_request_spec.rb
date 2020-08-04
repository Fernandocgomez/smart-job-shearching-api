require 'rails_helper'

RSpec.describe "Auths", type: :request do

  describe "POST /api/login" do
    before(:each) do
      @user = create_user
      @params = {"username" => "fernandocgomez", "password" => "Ilovemytacos32%"}
      @wrong_username_params = {"username" => "wronguser", "password" => "Ilovemytacos32%"}
      @wrong_password_params = {"username" => "fernandocgomez", "password" => "Ilovemytacos31%"}
    end
    context 'auth is succesful' do
      it 'returns a 200 status' do
        post "/api/login", params: @params

        expect(response).to have_http_status(200)
      end
      it 'returns an object with the user instance and a auth token on JSON' do
        post "/api/login", params: @params
        resp_json = JSON(response.body)
        matcher = get_user_matcher
        matcher['id'] = resp_json['resp']['user']['id']
        token = encode_token({user_id: @user.id})

        expect(resp_json['resp']).to match({"user" => matcher, "token" => token})
      end
    end
    context 'auth fails' do
      context 'wrong username' do
        it 'returns a 404 status' do
          post "/api/login", params: @wrong_username_params
  
          expect(response).to have_http_status(404)
        end
        it 'returns an error message on JSON' do
          post "/api/login", params: @wrong_username_params
          resp_json = JSON.parse(response.body)

          expect(resp_json["resp"]).to match("invalid username")
        end
      end
      context 'wrong password' do
        it 'returns a 401 status' do
          post "/api/login", params: @wrong_password_params
  
          expect(response).to have_http_status(401)
        end
        it 'returns an error message on JSON' do
          post "/api/login", params: @wrong_password_params
          resp_json = JSON.parse(response.body)

          expect(resp_json["resp"]).to match("invalid password")
        end
      end
    end
  end
end
