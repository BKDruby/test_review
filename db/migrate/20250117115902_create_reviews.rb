class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.text :text
      t.string :external_uid
      t.datetime :external_created_at
      t.float :rating
      t.string :author_uid
      t.references :listing, null: false, foreign_key: true

      t.timestamps
    end
  end
end
