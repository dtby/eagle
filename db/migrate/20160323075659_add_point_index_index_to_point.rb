class AddPointIndexIndexToPoint < ActiveRecord::Migration
  def change
    add_index :points, :point_index
  end
end
