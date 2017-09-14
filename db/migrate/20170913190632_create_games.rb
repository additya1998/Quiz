class CreateGames < ActiveRecord::Migration[5.1]
	def change
		create_table :games do |t|
            t.belongs_to :user
			t.string :category
			t.string :subCategory
			t.string :state
			t.integer :currentScore, :default => 0
			t.integer :highestScore, :default => 0
			t.timestamps
		end
	end
end
