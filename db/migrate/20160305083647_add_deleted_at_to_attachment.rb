class AddDeletedAtToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :deleted_at, :datetime
  end
end
