class AddMaxValueToPoint < ActiveRecord::Migration
  def change
    add_column :points, :max_value, :string
    add_column :points, :min_value, :string
  end
end
