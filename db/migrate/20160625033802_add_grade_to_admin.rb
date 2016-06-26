class AddGradeToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :grade, :integer, default: 1
  end
end
