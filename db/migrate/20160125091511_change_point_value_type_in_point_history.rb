class ChangePointValueTypeInPointHistory < ActiveRecord::Migration
  def change
    remove_column :point_histories, :point_value, :float
    add_column :point_histories, :point_value, :string
  end
end
