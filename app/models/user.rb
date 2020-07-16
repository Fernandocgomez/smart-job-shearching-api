class User < ApplicationRecord
  has_many :boards, dependent: :delete_all
  has_many :job_positions, dependent: :delete_all

  has_secure_password

  # https://guides.rubyonrails.org/active_record_validations.html

  # associations validations
  validates_associated :boards 
  validates_associated :job_positions 

  # Global validations
  validates :username, :email, :password_digest, :password_digest_confirmation, :first_name, :last_name, :street_address, :street_address_2, :city, :state, :zipcode, { 
    presence: true 
  }

  # username validations
  validates :username, {
              uniqueness: true,
              length: { within: 8..20 },
            }

  # email validations
  validates :email, {
              uniqueness: true,
              format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "email format is not valid" },
            }

  # password_digest validations
  validates :password_digest, {
              confirmation: true,
              length: { within: 8..40 },
            }
  validates :password_digest, { format: { with: /[a-z]+/, message: "must contain at least one lowercase letter" } }
  validates :password_digest, { format: { with: /[A-Z]+/, message: "must contain at least one uppercase letter" } }
  validates :password_digest, { format: { with: /\d+/, message: "must contain at least one digit" } }
  validates :password_digest, { format: { with: /[^A-Za-z0-9]+/, message: "must contain at least one special character" } }

  # first_name validations
  validates :first_name, {
    format: { with: /\A[a-zA-Z]*\z/, message: "only letters are allowed" },
    length: { within: 2..15 },
  }

  # last_name validations
  validates :last_name, {
    format: { with: /\A[a-zA-Z]*\z/, message: "only letters are allowed" },
    length: { within: 2..15 },
  }

  # street_address validations

  #   street_address_2 validations

  # city validations

  # state validations

  # zipcode validations
  validates :zipcode, {
              length: { is: 5 },
            }
end
