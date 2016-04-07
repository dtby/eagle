class AddStateToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :state, :boolean, default: false
  end
end
