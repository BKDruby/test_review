class Listing < ApplicationRecord
  belongs_to :user
  has_many :reviews, dependent: :destroy
  validates :url, presence: true, format: { with: URI.regexp(%w[http https]) }
end
