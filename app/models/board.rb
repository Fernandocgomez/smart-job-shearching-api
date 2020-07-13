class Board < ApplicationRecord
    has_many :columns
    belongs_to :user

    # associations validations
    validates_associated :columns

    # global validations
    validates :name, :user_id, { presence: true }

    # name validations
    validates :name, {length: { within: 2..20 }, format: { with: /\A[a-zA-Z\s]+\z/, message: "name format is not valid" }}



end
