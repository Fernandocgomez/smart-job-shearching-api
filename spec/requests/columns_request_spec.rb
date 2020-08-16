require "rails_helper"

RSpec.describe "Columns", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, username: "cristobalgomez", email: "cristobal@live.com") }

  let(:token) { get_auth_token(user.id) }
  let(:other_user_token) { get_auth_token(other_user.id) }

  let(:board) { create(:board, user_id: user.id) }

  let(:params) { get_column_params("valid", board.id) }
  let(:invalid_params) { get_column_params("invalid", board.id) }
  let(:update_params) { { "name" => "New updated name", "position" => 0 } }
  let(:invalid_update_params) { { "name" => "M" } }

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
    context 'when user tries to create a column not associated with its board' do
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

  describe "#update" do
    before(:each) do
      put "/api/column/#{column.id}", params: update_params, headers: token
      @resp_json = parse_resp_on_json(response)
    end
    context "when request success" do
      it "returns a 200 status" do
        expect(response).to have_http_status(200)
      end
      it "returns the updated instance of the Column model on JSON" do
        matcher = get_column_matcher(column.id, board.id)
        matcher["name"] = update_params["name"]
        expect(@resp_json).to match(matcher)
      end
    end
    context "when request fails becuase of an invalid id" do
      before(:each) do
        put "/api/column/#{column.id + 1}", params: update_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 404 status" do
        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to eql("column can't be found")
      end
    end
    context "when request fails becuase of invalid params" do
      before(:each) do
        put "/api/column/#{column.id}", params: invalid_update_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 400 status" do
        expect(response).to have_http_status(400)
      end
      it "returns an object of error messages in JSON" do
        expect(@resp_json).to_not match({})
        expect(@resp_json).to include("name")
      end
    end
    context 'when user tries to update a column not associated with his board' do
      before(:each) do
        put "/api/column/#{column.id}", params: update_params, headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not update a column that is not associated with one of yours boards without being an admin")
      end
    end
    context 'when position is updated to a greater value' do
      before(:each) do
        @column2 = create(:column, name: "My second column", position: 1, board_id: board.id)
        @column3 = create(:column, name: "My third column", position: 2, board_id: board.id)
        put "/api/column/#{column.id}", params: { "position" => 2 }, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'updates the position of the other columns that are on the range of the column old position to the column new position by minus 1' do
        expect(Column.find_by_id(@column2.id).position).to eq(0)
        expect(Column.find_by_id(@column3.id).position).to eq(1)
      end
    end
    context 'when the position is updated to a lower value' do
      before(:each) do
        @column1 = create(:column, name: "My first column", position: 0, board_id: board.id)
        @column2 = create(:column, name: "My second column", position: 1, board_id: board.id)
        @column3 = create(:column, name: "My third column", position: 2, board_id: board.id)
        put "/api/column/#{@column3.id}", params: { "position" => 0 }, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'updates the position of the other columns that are on the range of the column old position to the column new position by plus 1' do
        expect(Column.find_by_id(@column2.id).position).to eq(2)
        expect(Column.find_by_id(@column1.id).position).to eq(1)
      end
    end
    context 'when the position is updated to the same value' do
      before(:each) do
        put "/api/column/#{column.id}", params: { "position" => 0 }, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'it returns a 400 status' do
        expect(response).to have_http_status(400)
      end
      it 'returns an error message on JSON' do
        expect(@resp_json).to match("column has the same position value")
      end
    end
  end

  describe "#destroy" do
    context "when request is successful" do
      before(:each) do
        delete "/api/column/#{column.id}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 200 status" do
        expect(response).to have_http_status(200)
      end
      it "returns a confirmation message on JSON" do
        expect(@resp_json).to match("column has been deleted")
      end
      it "destroys record from the DB" do
        expect(Column.count).to eq(0)
      end
    end
    context "when request fails because of an invalid id" do
      before(:each) do
        delete "/api/column/#{column.id + 1}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 404 status" do
        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("column can't be found")
      end
    end
    context 'when user tries to delete a column not associated with his board' do
      before(:each) do
        delete "/api/column/#{column.id}", headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 401 status' do
        expect(response).to have_http_status(401)
      end
      it 'returns an error message on JSON' do
        expect(@resp_json).to match("you can not delete a column that is not associated with one of yours boards without being an admin")
      end
    end
    context 'when a column is deleted' do
      before(:each) do
        @column3 = create(:column, name: "My third column", position: 2, board_id: board.id)
        @column2 = create(:column, name: "My second column", position: 1, board_id: board.id)
        @column1 = create(:column, name: "My first column", position: 0, board_id: board.id)
        @column4 = create(:column, name: "My fourth column", position: 3, board_id: board.id)
        delete "/api/column/#{@column2.id}", headers: token
      end
      it 'updates the position of all the following columns' do
        expect(Column.find_by_id(@column1.id).position).to eq(0)
        expect(Column.find_by_id(@column3.id).position).to eq(1)
        expect(Column.find_by_id(@column4.id).position).to eq(2)
      end
    end
  end
end
