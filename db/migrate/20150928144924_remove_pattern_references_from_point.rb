class RemovePatternReferencesFromPoint < ActiveRecord::Migration
  def change
    remove_reference :points, :pattern, index: true, foreign_key: true
  end
end
