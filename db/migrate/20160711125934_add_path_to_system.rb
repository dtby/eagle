class AddPathToSystem < ActiveRecord::Migration
  def change
    add_column :systems, :path, :string
  end
end
