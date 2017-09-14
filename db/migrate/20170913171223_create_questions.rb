class CreateQuestions < ActiveRecord::Migration[5.1]
	def change
		create_table :questions do |t|
			t.string :question
			t.string :firstOption
			t.string :secondOption
			t.string :thirdOption
			t.string :fourthOption
			t.string :answer
			t.string :category
			t.string :subCategory
            t.string :type
			t.timestamps
		end
	end
end
