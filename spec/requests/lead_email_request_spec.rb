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
  


  # before(:each) do
  #   @user = create_user
  #   @company = create_company
  #   @board = create_board(@user.id)
  #   @column = create_column(@board.id)
  #   @lead = create_lead(@column.id, @company.id)
  #   @job_position = create_job_position(@user.id, @company.id)
  #   @lead_email_params = get_lead_email_params(@lead.id, @job_position.id)
  #   @lead_email_invalid_params = get_lead_email_invalid_params(@lead.id, @job_position.id)
  # end

  # describe "POST /api/lead_emails" do
  #   context "request is successful" do
  #     it "returns a 201 status" do
  #       post "/api/lead_emails", params: @lead_email_params

  #       expect(response).to have_http_status(201)
  #     end
  #     it "returns an instance of the LeadEmail model on JSON" do
  #       post "/api/lead_emails", params: @lead_email_params
  #       resp_json = JSON.parse(response.body)
  #       matcher = get_lead_email_matcher(@lead.id, @job_position.id, resp_json["resp"]["id"])

  #       expect(resp_json["resp"]).to match(matcher)
  #     end
  #     it "saves the lead_email on the DB" do
  #       db_size = LeadEmail.all.size
  #       post "/api/lead_emails", params: @lead_email_params

  #       expect(LeadEmail.all.size).to eq(db_size + 1)
  #     end
  #   end
  #   context "request fails" do
  #     it "returns a 400 status" do
  #       post "/api/lead_emails", params: @lead_email_invalid_params

  #       expect(response).to have_http_status(400)
  #     end
  #     it "returns an object of errors on JSON" do
  #       post "/api/lead_emails", params: @lead_email_invalid_params
  #       resp_json = JSON.parse(response.body)

  #       expect(resp_json["resp"]).to include("email")
  #       expect(resp_json["resp"]).to_not match({})
  #     end
  #   end
  # end
  # describe "GET /api/lead_email/:id" do
  #   before(:each) do
  #     post "/api/lead_emails", params: @lead_email_params
  #     @resp_lead_email = JSON.parse(response.body)
  #   end
  #   context "request is successful" do
  #     it "returns a 200 status" do
  #       get "/api/lead_email/#{@resp_lead_email["resp"]["id"]}"

  #       expect(response).to have_http_status(200)
  #     end
  #     it "returns an instance of the LeadEmail model on JSON based on the id provided" do
  #       get "/api/lead_email/#{@resp_lead_email["resp"]["id"]}"
  #       resp_json = JSON.parse(response.body)

  #       expect(resp_json["resp"]).to match(@resp_lead_email["resp"])
  #     end
  #   end
  #   context "request fails" do
  #     it "returns a 404 status" do
  #       get "/api/lead_email/#{@resp_lead_email["resp"]["id"] + 1}"

  #       expect(response).to have_http_status(404)
  #     end
  #     it "returns an error message on JSON" do
  #       get "/api/lead_email/#{@resp_lead_email["resp"]["id"] + 1}"
  #       resp_json = JSON.parse(response.body)

  #       expect(resp_json["resp"]).to eq("lead email can't be found")
  #     end
  #   end
  # end
  # describe "PUT /api/lead_email/:id" do
  #   before(:each) do
  #     post "/api/lead_emails", params: @lead_email_params
  #     @resp_lead_email = JSON.parse(response.body)
  #     @update_valid_params = { "email" => "new_email@example.com" }
  #     @update_invalid_params = { "email" => "new_invalid_email@examplecom" }
  #   end
  #   context "request is successful" do
  #     it "returns a 200 status" do
  #       put "/api/lead_email/#{@resp_lead_email["resp"]["id"]}", params: @update_valid_params

  #       expect(response).to have_http_status(200)
  #     end
  #     it "returns the updated instance of the LeadEmail model on JSON" do
  #       put "/api/lead_email/#{@resp_lead_email["resp"]["id"]}", params: @update_valid_params
  #       resp_json = JSON.parse(response.body)
  #       matcher = @resp_lead_email["resp"].clone
  #       matcher["email"] = @update_valid_params["email"]

  #       expect(resp_json["resp"]).to match(matcher)
  #     end
  #   end
  #   context "request fails(invalid params)" do
  #     it "returns a 400 status" do
  #       put "/api/lead_email/#{@resp_lead_email["resp"]["id"]}", params: @update_invalid_params

  #       expect(response).to have_http_status(400)
  #     end
  #     it "returns an object of errors of JSON" do
  #       put "/api/lead_email/#{@resp_lead_email["resp"]["id"]}", params: @update_invalid_params
  #       resp_json = JSON.parse(response.body)

  #       expect(resp_json["resp"]).to include("email")
  #       expect(resp_json["resp"]).to_not eq({})
  #     end
  #   end
  #   context "request fails(invalid id)" do
  #     it "returns a 404 status" do
  #       put "/api/lead_email/#{@resp_lead_email["resp"]["id"] + 1}", params: @update_valid_params

  #       expect(response).to have_http_status(404)
  #     end
  #     it "returns an error message on JSON" do
  #       put "/api/lead_email/#{@resp_lead_email["resp"]["id"] + 1}", params: @update_valid_params
  #       resp_json = JSON.parse(response.body)

  #       expect(resp_json["resp"]).to eq("lead email can't be found")
  #     end
  #   end
  # end
  # describe "DELETE /api/lead_email/:id" do
  #   before(:each) do
  #     post "/api/lead_emails", params: @lead_email_params
  #     @resp_lead_email = JSON.parse(response.body)
  #   end
  #   context "request is successful" do
  #     it "returns a 200 status" do
  #       delete "/api/lead_email/#{@resp_lead_email["resp"]["id"]}"

  #       expect(response).to have_http_status(200)
  #     end
  #     it "returns a confirmatino message on JSON" do
  #       delete "/api/lead_email/#{@resp_lead_email["resp"]["id"]}"
  #       resp_json = JSON.parse(response.body)

  #       expect(resp_json["resp"]).to eq("lead email has been deleted")
  #     end
  #     it "destroy record from the DB" do
  #       db_size = LeadEmail.all.size
  #       delete "/api/lead_email/#{@resp_lead_email["resp"]["id"]}"

  #       expect(LeadEmail.all.size).to eq(db_size - 1)
  #     end
  #   end
  #   context "request fails" do
  #     it "returns a 404 status" do
  #       delete "/api/lead_email/#{@resp_lead_email["resp"]["id"] + 1}"

  #       expect(response).to have_http_status(404)
  #     end
  #     it "returns an error message on JSON" do
  #       delete "/api/lead_email/#{@resp_lead_email["resp"]["id"] + 1}"
  #       resp_json = JSON.parse(response.body)

  #       expect(resp_json["resp"]).to eq("lead email can't be found")
  #     end
  #   end
  # end
end
