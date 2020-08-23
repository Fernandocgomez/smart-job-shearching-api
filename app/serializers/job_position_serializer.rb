class JobPositionSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :city, :state, :applied, :company_id
end
