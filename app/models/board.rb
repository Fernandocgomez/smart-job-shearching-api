class Board < ApplicationRecord
    has_many :columns
    belongs_to :user
end
