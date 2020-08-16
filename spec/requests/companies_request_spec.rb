require "rails_helper"

RSpec.describe "Companies", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, username: "cristobalgomez", email: "cristobal@live.com") }

  let(:token) { get_auth_token(user.id) }
  let(:other_user_token) { get_auth_token(other_user.id) }

  let(:params) { get_company_params("valid", user.id) }
  let(:invalid_params) { get_company_params("invalid", user.id) }
  let(:wrong_id_params) { get_company_params("valid", other_user.id) }
  let(:update_params) { { "name" => "the new updated name" } }
  let(:invalid_update_params) { { "name" => nil } }

  let(:company) { create(:company, user_id: user.id) }

  describe "#create" do

    context "when request is successful" do
      before(:each) do
        post "/api/companies", params: params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 201 status" do
        expect(response).to have_http_status(201)
      end
      it "returns the company instance on JSON" do
        expect(@resp_json).to match(get_company_matcher(@resp_json["id"], user.id))
      end
      it "saves the company instance on the DB" do
        expect(Company.count).to eq(1)
      end
    end

    context "when request fails becuase of invalid params" do
      before(:each) do
        post "/api/companies", params: invalid_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 400 status" do
        expect(response).to have_http_status(400)
      end
      it "returns an object of errors on JSON" do
        expect(@resp_json).to include("name")
        expect(@resp_json).to_not eq({})
      end
    end

    context 'when user tries to create a company not associated with its id' do
      before(:each) do
        post "/api/companies", params: wrong_id_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 401 status' do
        expect(response).to have_http_status(401)
      end
      it 'returns an error message on JSON' do
        expect(@resp_json).to match("you can not create a company that is not associated with your user without being an admin")
      end
    end

  end

  describe "#show" do

    context "when request is successful" do
      before(:each) do
        get "/api/company/#{company.id}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 200 status" do
        expect(response).to have_http_status(200)
      end
      it "returns the instance of the Company model on JSON based on the id provided" do
        expect(@resp_json).to eq(get_company_matcher(@resp_json["id"], user.id))
      end
    end

    context "when request fails becuase of an invalid id" do
      before(:each) do
        get "/api/company/#{company.id + 1}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 404 status" do
        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to eq("company can't be found")
      end
    end

    context 'when user tries to access a company associated to another user' do
      before(:each) do
        get "/api/company/#{company.id}", headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 401 status' do
        expect(response).to have_http_status(401)
      end
      it 'returns an error message on JSON' do
        expect(@resp_json).to match("you can not access to other users' company without being an admin")
      end
    end

  end

  describe "#update" do
    
    context "when request is successful" do
      before(:each) do
        put "/api/company/#{company.id}", params: update_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 200 status" do
        expect(response).to have_http_status(200)
      end
      it "returns the updated instance of the Company model on JSON" do
        matcher = get_company_matcher(company.id, user.id)
        matcher["name"] = update_params["name"]

        expect(@resp_json).to match(matcher)
      end
    end

    context "when request fails becuase of invalid parmas" do
      before(:each) do
        put "/api/company/#{company.id}", params: invalid_update_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 400 status" do
        expect(response).to have_http_status(400)
      end
      it "returns an object of errors of JSON" do
        expect(@resp_json).to include("name")
        expect(@resp_json).to_not eq({})
      end
    end

    context "when request fails becuase of an invalid id" do
      before(:each) do
        put "/api/company/#{company.id + 1}", params: update_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 404 status" do
        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to eq("company can't be found")
      end
    end

    context 'when request fails because user tries to update a company not associated with its account' do
      before(:each) do
        put "/api/company/#{company.id}", params: update_params, headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 401 status' do
        expect(response).to have_http_status(401)
      end
      it 'returns an error message on JSON' do
        expect(@resp_json).to match("you can not update a company that is not associated with your user without being an admin")   
      end
    end

  end

  describe "#destroy" do

    context "when request is successful" do
      before(:each) do
        delete "/api/company/#{company.id}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 200 status" do
        expect(response).to have_http_status(200)
      end
      it "returns a confirmatino message on JSON" do
        expect(@resp_json).to eq("company has been deleted")
      end
      it "destroy record from the DB" do
        expect(Company.count).to eq(0)
      end
    end

    context "when request fails because of an invalid id" do
      before(:each) do
        delete "/api/company/#{company.id + 1}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 404 status" do
        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to eq("company can't be found")
      end
    end

    context 'when a user tries to delete a company not associated with its account' do
      before(:each) do
        delete "/api/company/#{company.id}", headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 401 status' do
        expect(response).to have_http_status(401)
      end
      it 'returns a error message on JSON' do
        expect(@resp_json).to match("you can not delete a company that is not associated with your user without being an admin")
      end
    end
    
  end
end
