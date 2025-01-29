class AddUniqueIndexToReviewsExternalUid < ActiveRecord::Migration[8.0]
  def change
    add_index :reviews, :external_uid, unique: true
  end
end
