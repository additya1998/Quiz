class CreateGames < ActiveRecord::Migration[5.1]
	def change
		create_table :games do |t|
            t.belongs_to :user
			t.string :category
			t.string :subCategory
			t.string :state
			t.integer :currentScore
			t.integer :highestScore
			t.timestamps
		end
	end
end
