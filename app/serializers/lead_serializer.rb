class LeadSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :picture_url, :linkedin_url, :status, :notes, :email, :phone_number, :position, :column_id, :company_id
end
