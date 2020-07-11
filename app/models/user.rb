class User < ApplicationRecord
    has_many :boards
    validates :username, presence: true
end
