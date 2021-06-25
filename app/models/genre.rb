class Genre < ApplicationRecord
    has_many :items, presence: true
    
    validates :name, presence: true
end
