class AddAreaIdToRoom < ActiveRecord::Migration
  def change
    add_reference :rooms, :area, index: true, foreign_key: true
  end
end
