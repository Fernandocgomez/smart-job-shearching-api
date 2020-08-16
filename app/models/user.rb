class User < ApplicationRecord
  has_many :boards, dependent: :delete_all
  has_many :companies, dependent: :delete_all


  has_secure_password

  # https://guides.rubyonrails.org/active_record_validations.html

  # associations validations
  validates_associated :boards 
  validates_associated :companies 

  # Global validations
  validates :username, :email, :password, :password_confirmation, :first_name, :last_name, :city, :state, :zipcode, { 
    presence: true 
  }

  # username validations
  validates :username, {
              uniqueness: true,
              length: { within: 8..20 },
              format: { with: /\A[a-zA-Z]*\z/, message: "only letters are allowed" },
            }

  # email validations
  validates :email, {
              uniqueness: true,
              format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "email format is not valid" },
            }

  # password_digest validations
  validates :password, {
              confirmation: true,
              length: { within: 8..25 },
            }
  validates :password, { format: { with: /[a-z]+/, message: "must contain at least one lowercase letter" } }
  validates :password, { format: { with: /[A-Z]+/, message: "must contain at least one uppercase letter" } }
  validates :password, { format: { with: /\d+/, message: "must contain at least one digit" } }
  validates :password, { format: { with: /[^A-Za-z0-9]+/, message: "must contain at least one special character" } }

  # first_name & last_name validations
  validates :first_name, :last_name, {
    format: { with: /\A[a-zA-Z]*\z/, message: "only letters are allowed" },
    length: { within: 2..15 },
  }

  # city validations

  # state validations

  # zipcode validations
  validates :zipcode, {
              length: { is: 5 },
              numericality: { only_integer: true }
            }
end
