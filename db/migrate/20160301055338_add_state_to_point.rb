class AddStateToPoint < ActiveRecord::Migration
  def change
    add_column :points, :state, :boolean, default: true
  end
end
