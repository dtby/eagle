class ChangeAdmins < ActiveRecord::Migration
	def change
		change_table :admins do |t|
			t.string :name, null: false, default: ""
			t.string :phone, null: false, default: ""
		end

		add_index :admins, :phone, unique: true
	end
end
