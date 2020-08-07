require "rails_helper"
RSpec.describe "Boards", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, username: "cristobalgomez", email: "cristobal@live.com") }
  let(:token) { get_auth_token(user.id) }
  let(:other_user_token) { get_auth_token(other_user.id) }
  let(:params) { get_board_params("valid", user.id) }
  let(:invalid_params) { get_board_params("invalid", user.id) }
  let(:other_user_id_params) { get_board_params("valid", other_user.id) }
  let(:board) { create(:board, user_id: user.id) }

  describe "#create" do
    context "when request success" do
      before(:each) do
        post "/api/boards", params: params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 201 status" do
        expect(response).to have_http_status(201)
      end
      it "returns an instance of the Board model on JSON" do
        matcher = get_board_matcher(@resp_json["id"], user.id)

        expect(@resp_json).to match(matcher)
      end
      it "saves the instance of the Board on the DB" do
        expect(Board.all.size).to eq(1)
      end
    end
    context "when request fails" do
      before(:each) do
        post "/api/boards", params: invalid_params, headers: token
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
    context "when user tries to create a board not associated with him" do
      before(:each) do
        post "/api/boards", params: other_user_id_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not create board that are not associated with your user without being an admin")
      end
    end
  end

  describe "#show" do
    context "when request is successful" do
      before(:each) do
        get "/api/board/#{board.id}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 200 status" do
        expect(response).to have_http_status(200)
      end
      it "returns an instance of the Board model on JSON basedon the id provided" do
        expect(@resp_json).to match(get_board_matcher(board.id, user.id))
      end
    end
    context "when request fails" do
      before(:each) do
        get "/api/board/#{board.id + 1}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 404 status" do
        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to eq("board can't be found")
      end
    end
    context "when user tries to access other user board" do
      before(:each) do
        get "/api/board/#{board.id}", headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not access to other users' boards without being an admin")
      end
    end
  end

  describe "#update" do
    let(:update_params) { { "name" => "different name" } }
    let(:invalid_update_params) { { "name" => nil } }
    context "when request success" do
      before(:each) do
        put "/api/board/#{board.id}", params: update_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 200 status" do
        expect(response).to have_http_status(200)
      end
      it "returns the updated instance of the Board model on JSON" do
        expect(@resp_json["name"]).to match(update_params["name"])
      end
    end
    context "when request fails(invalid params)" do
      before(:each) do
        put "/api/board/#{board.id}", params: invalid_update_params, headers: token
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
    context "when request fails(invalid id)" do
      before(:each) do
        put "/api/board/#{board.id + 1}", params: update_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 4040 status" do
        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to eq("board can't be found")
      end
    end
    context "when user tries to edit other user board" do
      before(:each) do
        put "/api/board/#{board.id}", headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not edit other users' boards without being an admin")
      end
    end
  end

  describe "#destroy" do
    context "when request is successful" do
      before(:each) do
        delete "/api/board/#{board.id}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 200 status" do
        expect(response).to have_http_status(200)
      end
      it "returns a confirmation message on JSON" do
        expect(@resp_json).to eq("board has been deleted")
      end
      it "destroy record from the DB" do
        expect(Board.all.size).to eq(0)
      end
    end
    context "when request fails" do
      before(:each) do
        delete "/api/board/#{board.id + 1}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 404 status" do
        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to eq("board can't be found")
      end
    end
    context "when user tries to delete other user board" do
      before(:each) do
        delete "/api/board/#{board.id}", headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not delete other users' boards without being an admin")
      end
    end
  end
end
