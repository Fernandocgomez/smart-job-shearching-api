class LeadEmailSerializer < ActiveModel::Serializer
  attributes :id, :email, :subject, :email_body, :sent, :open, :lead_id, :job_position_id
end
