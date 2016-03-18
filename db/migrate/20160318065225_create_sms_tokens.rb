class CreateSmsTokens < ActiveRecord::Migration
  def change
    create_table :sms_tokens do |t|

      t.timestamps null: false
    end
  end
end
