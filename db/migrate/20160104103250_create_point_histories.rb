class CreatePointHistories < ActiveRecord::Migration
  def change
    create_table :point_histories do |t|
      t.string :point_name
      t.float :point_value
      t.references :point, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
