class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :first_name, :last_name, :street_address, :street_address_2, :city, :state, :zipcode
end
