class AddPointTypeToPoint < ActiveRecord::Migration
  def change
    add_column :points, :point_type, :integer
  end
end
