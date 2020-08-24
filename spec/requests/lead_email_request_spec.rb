require "rails_helper"

RSpec.describe "LeadEmails", type: :request do
  
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

  let(:lead) { create(:lead, column_id: column.id, company_id: company.id) }
  let(:other_user_lead) { create(:lead, column_id: other_user_column.id, company_id: other_user_company.id) }
  
  let(:job_position) { create(:job_position, company_id: company.id) }
  let(:other_user_job_position) { create(:job_position, company_id: company.id) }

  let(:lead_email) { create(:lead_email, lead_id: lead.id, job_position_id: job_position.id) }
  
  let(:params) { get_lead_email_params("valid", lead.id, job_position.id) }
  let(:invalid_params) { get_lead_email_params("invalid", lead.id, job_position.id) }
  let(:update_params) { {"sent" => true} }
  let(:invalid_update_params) { {"email" => "example@examplecom"} }

  describe '#create' do
    
    context 'when request is successful' do
      before(:each) do
        post "/api/lead_emails", params: params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 201 status' do
        expect(response).to have_http_status(201)
      end
      it 'returns an instance of the LeadEmail model on JSON' do
        matcher = get_lead_email_matcher(@resp_json["id"], lead.id, job_position.id)
        expect(@resp_json).to match(matcher)
      end
      it 'saves the lead_email on the DB' do
        expect(LeadEmail.count).to eq(1)
      end
    end

    context 'when request fails becuase of invalid params' do
      before(:each) do
        post "/api/lead_emails", params: invalid_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 400 status" do
        expect(response).to have_http_status(400)
      end
      it 'returns an object of errors on JSON' do
        expect(@resp_json).to include("email")
        expect(@resp_json).to_not match({})
      end
    end

    context "when a user tries to create a lead_email not associated with one of its leads or job_positions" do
      before(:each) do
        post "/api/lead_emails", params: params, headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not create a lead_email that is not associated with one of yours job_postions or leads without being an admin")
      end
    end

  end

  describe '#show' do
    
    context 'when request is succesful' do
      before(:each) do
        get "/api/lead_email/#{lead_email.id}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 200 status' do
        expect(response).to have_http_status(200)
      end
      it 'returns an instance of the LeadEmail model on JSON based on the id provided' do
        matcher = get_lead_email_matcher(@resp_json["id"], lead.id, job_position.id)

        expect(@resp_json).to match(matcher)
      end
      
    end

    context 'when request fails because of an invalid id' do
      before(:each) do
        get "/api/lead_email/#{lead_email.id + 1}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 404 status' do
        expect(response).to have_http_status(404)
      end
      it 'returns an error message on JSON' do
        expect(@resp_json).to eq("lead email can't be found")
      end
    end

    context 'when a user tries to access a lead_email not associated with one of its leads or job_positions' do
      before(:each) do
        get "/api/lead_email/#{lead_email.id}", headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not access a lead_email that is not associated with one of yours job_postions or leads without being an admin")
      end
    end
    
  end

  describe '#update' do

    context 'when request is successful' do
      before(:each) do
        put "/api/lead_email/#{lead_email.id}", params: update_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 200 status' do
        expect(response).to have_http_status(200)
      end
      it 'returns an updated instance of the LeadEmail model on JSON' do
        matcher = get_lead_email_matcher(lead_email.id, lead.id, job_position.id)
        matcher["sent"] = true

        expect(@resp_json).to match(matcher)
      end
    end

    context 'when request fails because of invalid params' do
      before(:each) do
        put "/api/lead_email/#{lead_email.id}", params: invalid_update_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 400 status' do
        expect(response).to have_http_status(400)
      end
      it 'returns an obj og error on JSON' do
        expect(@resp_json).to include("email")
        expect(@resp_json).to_not eq({})
      end
    end

    context 'when request fails because of an invalid id' do
      before(:each) do
        put "/api/lead_email/#{lead_email.id + 1}", params: update_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns 404 status' do
        expect(response).to have_http_status(404)
      end
      it 'returns an error message on JSON' do
        expect(@resp_json).to eq("lead email can't be found")
      end
    end

    context 'when a user tries to update a lead_email not associated with one of its leads or job_positions' do
      before(:each) do
        put "/api/lead_email/#{lead_email.id}", params: update_params, headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not update a lead_email that is not associated with one of yours job_postions or leads without being an admin")
      end
    end

  end

  describe '#destroy' do
    
    context 'when request is succesful' do
      before(:each) do
        delete "/api/lead_email/#{lead_email.id}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 200 status' do
        expect(response).to have_http_status(200)
      end
      it 'returns a confirmation message on JSON' do
        expect(@resp_json).to eq("lead email has been deleted")
      end
      it 'destroyes record from the DB' do
        expect(LeadEmail.count).to eq(0) 
      end
    end

    context 'when request fails becuase of an invalid id' do
      before(:each) do
        delete "/api/lead_email/#{lead_email.id + 1}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 404 status' do
        expect(response).to have_http_status(404)
      end
      it 'returns an error message on JSON' do
        expect(@resp_json).to eq("lead email can't be found")
      end
    end

    context 'when a user tries to delete a lead_email not associated with one of its leads or job_positions' do
      before(:each) do
        delete "/api/lead_email/#{lead_email.id}", headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not delete a lead_email that is not associated with one of yours job_postions or leads without being an admin")
      end
    end
    
  end
  
end
