class JobPositionSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :city, :state, :applied, :user_id, :company_id
end
