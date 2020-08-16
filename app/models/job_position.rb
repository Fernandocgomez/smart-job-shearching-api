class JobPosition < ApplicationRecord
    has_many :lead_emails, dependent: :delete_all
    belongs_to :company

    validates_associated :lead_emails

    # Global validations
    validates :name, :description, :city, :state, {
        presence: true
    }

    # name validations

    # description validations

    # must not contain a single double quotes (") (future)

    # city validations

    # state validations
    
    validates :state, {
        length: { is: 2 },
        format: { with: /\A[a-zA-Z]*\z/ },
    }

    # applied validations

    validates_inclusion_of :applied, :in => [true, false]

    # user_id validations

    # company_id validations

end
