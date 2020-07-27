class LeadEmail < ApplicationRecord
    belongs_to :lead
    belongs_to :job_position

    # global validations
    validates :email, :email_body, :subject, { 
        presence: true 
    }

    # email validations
    validates :email, {
        format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "email format is not valid" },
    }

    # subject validations
    validates :subject, {
        length: { within: 15..70 },
        format: { with: /\A[a-zA-Z0-9\s]+\z/, message: "only letters, numbers and spaces are allowed" }
    }

    # email_body validations

    # sent & open validations
    validates_inclusion_of :sent, :open, :in => [true, false]

    # lead_id validations

    # job_position_id validations

end
