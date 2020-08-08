require "rails_helper"

RSpec.describe "Columns", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, username: "cristobalgomez", email: "cristobal@live.com") }

  let(:token) { get_auth_token(user.id) }
  let(:other_user_token) { get_auth_token(other_user.id) }

  let(:board) { create(:board, user_id: user.id) }
  let(:other_user_board) { create(:board, user_id: other_user.id) }

  let(:params) { get_column_params("valid", board.id) }
  let(:invalid_params) { get_column_params("invalid", board.id) }

  let(:column) { create(:column, board_id: board.id) }

  describe "#create" do
    context "when request success" do
      before(:each) do
        post "/api/columns", params: params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 201 status" do
        expect(response).to have_http_status(201)
      end
      it "returns an instance of the Column model in JSON" do
        matcher = get_column_matcher(@resp_json['id'], board.id)
        expect(@resp_json).to match(matcher)
      end
      it "saves the instance of the Column on the DB" do
        expect(Column.count).to eql(1)
      end
    end
    context 'when a new record is created' do
      before(:each) do
        post "/api/columns", params: params, headers: token
        post "/api/columns", params: params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'updates the postion attribute to match the number of columns associated with the board' do
        expect(@resp_json["position"]).to eql(1)
      end
    end
    context "when request fails becuase of invalid params" do
      before(:each) do
        post "/api/columns", params: invalid_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 400 status" do
        expect(response).to have_http_status(400)
      end
      it "returns an object of errors on JSON" do
        expect(@resp_json).to_not match({})
        expect(@resp_json).to include("name")
      end
    end
    context 'when user tries to create a column not associated with his board' do
      before(:each) do
        post "/api/columns", params: params, headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not create a column that is not associated with one of yours boards without being an admin")
      end
    end
  end

  # describe "PUT /api/column/:id" do
  #   before(:each) do
  #     post "/api/columns", params: @params
  #     # @column_resp = JSON.parse(response.body)
  #     @column_resp = JSON.parse(response.body)
  #     @update_params = { "name" => "New updated name" }
  #     @update_invalid_params = { "name" => "M" }
  #   end
  #   context "request is succesful" do
  #     it "returns a 200 status" do
  #       put "/api/column/#{@column_resp["resp"]["id"]}", params: @update_params

  #       expect(response).to have_http_status(200)
  #     end
  #     it "returns the updated instance of the Column model on JSON" do
  #       put "/api/column/#{@column_resp["resp"]["id"]}", params: @update_params
  #       resp_json = JSON.parse(response.body)
  #       @matcher["id"] = @column_resp["resp"]["id"]
  #       @matcher["name"] = @update_params["name"]

  #       expect(resp_json["resp"]).to match(@matcher)
  #     end
  #   end
  #   context "request fails(invalid id)" do
  #     it "returns a 404 status" do
  #       put "/api/column/#{@column_resp["resp"]["id"] + 1}", params: @update_params

  #       expect(response).to have_http_status(404)
  #     end
  #     it "returns an error message on JSON" do
  #       put "/api/column/#{@column_resp["resp"]["id"] + 1}", params: @update_params
  #       resp_json = JSON.parse(response.body)

  #       expect(resp_json["resp"]).to eql("column can't be found")
  #     end
  #   end
  #   context "request fails(invalid paramas)" do
  #     it "returns a 400 status" do
  #       put "/api/column/#{@column_resp["resp"]["id"]}", params: @update_invalid_params

  #       expect(response).to have_http_status(400)
  #     end
  #     it "returns an object of error messages in JSON" do
  #       put "/api/column/#{@column_resp["resp"]["id"]}", params: @update_invalid_params

  #       resp_json = JSON.parse(response.body)

  #       expect(resp_json["resp"]).to_not match({})
  #       expect(resp_json["resp"]).to include("name")
  #     end
  #   end
  # end

  # describe "DELETE /api/column/:id" do
  #   before(:each) do
  #     post "/api/columns", params: @params
  #     @column_resp = JSON.parse(response.body)
  #   end
  #   context "request is successful" do
  #     it "returns a 200 status" do
  #       delete "/api/column/#{@column_resp["resp"]["id"]}"

  #       expect(response).to have_http_status(200)
  #     end
  #     it "returns a confirmation message on JSON" do
  #       delete "/api/column/#{@column_resp["resp"]["id"]}"
  #       resp_json = JSON.parse(response.body)

  #       expect(resp_json["resp"]).to eql("column has been deleted")
  #     end
  #     it "destroy record from the DB" do
  #       db_size = Column.all.size
  #       delete "/api/column/#{@column_resp["resp"]["id"]}"

  #       expect(Column.all.size).to eq(db_size - 1)
  #     end
  #   end
  #   context "request fails" do
  #     it "returns a 404 status" do
  #       delete "/api/column/#{@column_resp["resp"]["id"] + 1}"
  #       expect(response).to have_http_status(404)
  #     end
  #     it "rreturns an error message on JSON" do
  #       delete "/api/column/#{@column_resp["resp"]["id"] + 1}"
  #       resp_json = JSON.parse(response.body)

  #       expect(resp_json["resp"]).to eql("column can't be found")
  #     end
  #   end
end
