class Listing < ApplicationRecord
  belongs_to :user
  has_many :reviews, dependent: :destroy
  validates :url, presence: true, format: { with: URI.regexp(%w[http https]) }
  enum :scrape_status, { in_progress: 0, ready: 1 }

  def words_frequencies
    query = <<-SQL
      SELECT word, COUNT(*) 
      FROM (
        SELECT unnest(regexp_split_to_array(lower(text), '\\s+')) AS word
        FROM reviews
      ) AS words
      WHERE word NOT IN (?)
      GROUP BY word
      ORDER BY COUNT(*) DESC
    SQL

    results = ActiveRecord::Base.connection.execute(ActiveRecord::Base.send(:sanitize_sql_array, [query, Review::SKIP_WORDS]))

    results.map { |row| { word: row['word'], count: row['count'] } }
  end
  
  def chart_data
    reviews.monthly_reviews
  end
end
