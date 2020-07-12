require 'rails_helper'

RSpec.describe "Boards", type: :request do
    before(:each) do
        @user = User.create(
            username: "fernandocgomez", 
            email: "fernandocgomez@live.com", 
            password_digest: "Ilovemytacos32%",
            password_digest_confirmation: "Ilovemytacos32%",
            first_name: "Fernando", 
            last_name: "Gomez", 
            street_address: "11900 City Park Central Ln", 
            street_address_2: "7210", 
            city: "Houston", 
            state: "Tx", 
            zipcode: "77047"
        )

        @params = {
            name: "My first board", 
            user_id: @user.id
        }

        @resp_matcher = {
            "name" => @params[:name], 
            "user_id" => @params[:user_id]
        }
    end

  describe "POST /create" do
    context "if request is succesful when passing params" do 
        it "returns http success" do
            post "/create", params: @params
            expect(response).to have_http_status(201)
        end

        it "saves the instance on the db" do 
            db_size = Board.all.size
            post "/create", params: @params
            expect(Board.all.size).to_not eql(db_size)
        end 

        it "returns an instance of the Board in JSON" do 
            post "/create", params: @params
            json = JSON.parse(response.body)
            @resp_matcher['id'] = json['resp']['id']

            expect(json['resp']).to match(@resp_matcher)
        end
    end 

    context "if request fails" do 
        it "returns http success" do
            @params[:name] = nil
            post "/create", params: @params

            expect(response).to have_http_status(400)
        end

        it "return an  array of error messages" do 
            @params[:name] = nil
            post "/create", params: @params
            json = JSON.parse(response.body)

            expect(json['resp']).to_not match({})
        end 
    end
    
  end

#   describe "GET /show" do
#     it "returns http success" do
#       get "/boards/show"
#       expect(response).to have_http_status(:success)
#     end
#   end

#   describe "GET /update" do
#     it "returns http success" do
#       get "/boards/update"
#       expect(response).to have_http_status(:success)
#     end
#   end

#   describe "GET /destroy" do
#     it "returns http success" do
#       get "/boards/destroy"
#       expect(response).to have_http_status(:success)
#     end
#   end

end
