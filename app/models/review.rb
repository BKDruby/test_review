class Review < ApplicationRecord
  SKIP_WORDS = %w(the and or a in of was to we is for our had it this as i were you an all be but at us host on so from has are)

  belongs_to :listing

  def self.monthly_reviews
    select("DATE_TRUNC('month', external_created_at) AS month, COUNT(*) AS count")
      .group("DATE_TRUNC('month', external_created_at)")
      .order("month")
      .map do |review|
      {
        month: review.month.strftime("%B %Y"),
        count: review.count
      }
    end
  end
end
