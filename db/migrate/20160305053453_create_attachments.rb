class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :image
      t.string :tag
      t.references :room, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
