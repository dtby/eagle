class AddPointIndexToPoint < ActiveRecord::Migration
  def change
    add_column :points, :point_index, :string
  end
end
