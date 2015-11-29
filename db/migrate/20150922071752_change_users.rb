class ChangeUsers < ActiveRecord::Migration
	def change
		change_table :users do |t|
			t.string :name, null: false, default: ""
			t.string :phone, null: false, default: ""
		end

		add_index :users, :phone, unique: true
	end
end
