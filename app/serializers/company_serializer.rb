class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :linkedin_url, :website, :about
end
