class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.string :name
      t.references :pattern, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
