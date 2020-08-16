require "rails_helper"

RSpec.describe "Leads", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, username: "cristobalgomez", email: "cristobal@live.com") }

  let(:token) { get_auth_token(user.id) }
  let(:other_user_token) { get_auth_token(other_user.id) }
  
  let(:board) { create(:board, user_id: user.id) }
  let(:other_user_board) { create(:board, user_id: other_user.id) }

  let(:column) { create(:column, board_id: board.id) }
  let(:other_user_column) { create(:column, board_id: other_user_board.id) }

  let(:company) { create(:company, user_id: user.id) }
  let(:other_user_company) { create(:company, user_id: other_user.id) }

  let(:params) { get_lead_params("valid", column.id, company.id) }
  let(:invalid_params) { get_lead_params("invalid", column.id, company.id) }
  let(:update_params) { { "first_name" => "Juan", "position" => 0 } }
  let(:invalid_update_params) { { "first_name" => nil } }

  let(:lead) { create(:lead, column_id: column.id, company_id: company.id) }


  describe "#create" do

    context "when request is successful" do
      before(:each) do
        post "/api/leads", params: params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 201 status" do
        expect(response).to have_http_status(201)
      end
      it "returns an instance of the Lead model on JSON" do
        matcher = get_lead_matcher(@resp_json["id"], column.id, company.id)

        expect(@resp_json).to match(matcher)
      end
      it "saves the lead on the DB" do
        expect(Lead.count).to eq(1)
      end
    end

    context "when request fails because of invalid params" do
      before(:each) do
        post "/api/leads", params: invalid_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 400 status" do
        expect(response).to have_http_status(400)
      end
      it "returns an object of errors on JSON" do
        expect(@resp_json).to include("first_name")
        expect(@resp_json).to_not eq({})
      end
    end

    context 'when user tries to create a lead not associated with one of its columns' do
      before(:each) do
        post "/api/leads", params: params, headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not create a lead that is not associated with one of yours columns without being an admin")
      end
    end

  end

  describe "#show" do

    context "when request is succesful" do
      before(:each) do
        get "/api/lead/#{lead.id}", params: params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 200 status" do
        expect(response).to have_http_status(200)
      end
      it "returns an instance of the Lead model on JSON based on the id passed" do
        matcher = get_lead_matcher(@resp_json["id"], column.id, company.id)
        expect(@resp_json).to match(matcher)
      end
    end

    context "when request fails becuase of an invalid id was passed" do
      before(:each) do
        get "/api/lead/#{lead.id + 1}", params: params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 404 status" do
        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("lead can't be found")
      end
    end
    
    context 'when user tries to access a lead not associated with its columns' do
      before(:each) do
        get "/api/lead/#{lead.id}", params: params, headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not access a lead that is not associated with one of yours columns without being an admin")
      end
    end

  end

  describe "#update" do

    context "when request is succesful" do
      before(:each) do
        put "/api/lead/#{lead.id}", params: update_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 200 status" do
        expect(response).to have_http_status(200)
      end
      it "returns the updated instance of the Lead model on JSON" do
        matcher = get_lead_matcher(@resp_json["id"], column.id, company.id)
        matcher["first_name"] = update_params["first_name"]
        expect(@resp_json).to match(matcher)
      end
    end

    context "when request fails becuase of invalid params" do
      before(:each) do
        put "/api/lead/#{lead.id}", params: invalid_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 400 status" do
        expect(response).to have_http_status(400)
      end
      it "returns an object of errors of JSON" do
        expect(@resp_json).to include("first_name")
        expect(@resp_json).to_not eq({})
      end
    end

    context "when request fails becuase of an invalid id" do
      before(:each) do
        put "/api/lead/#{lead.id + 1}", params: update_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 404 status" do
        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("lead can't be found")
      end
    end

    context 'when user tries to update a lead not associated with on of its column' do
      before(:each) do
        put "/api/lead/#{lead.id}", params: update_params, headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not update a lead that is not associated with one of yours columns without being an admin")
      end
    end
  end

  describe "#destroy" do
    
    context "when request is succesful" do
      before(:each) do
        delete "/api/lead/#{lead.id}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 200 status" do
        expect(response).to have_http_status(200)
      end
      it "returns a confirmatino message on JSON" do
        expect(@resp_json).to eq("lead has been deleted")
      end
      it "destroy record from the DB" do
        expect(Lead.count).to eq(0)
      end
    end

    context "when request fails becuase of an invalid id" do
      before(:each) do
        delete "/api/lead/#{lead.id + 1}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 404 status" do
        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("lead can't be found")
      end
    end

    context 'when user tries to delete a lead not associated with one of its columns' do
      before(:each) do
        delete "/api/lead/#{lead.id}", headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not delete a lead that is not associated with one of yours columns without being an admin")
      end
    end

  end
end

