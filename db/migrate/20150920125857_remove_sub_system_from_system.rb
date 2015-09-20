class RemoveSubSystemFromSystem < ActiveRecord::Migration
  def change
    remove_column :systems, :sub_system, :string
  end
end
