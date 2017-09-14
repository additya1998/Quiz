class AddQuestionsJob < ApplicationJob
	queue_as :default

	def perform
		require 'open-uri'
		require 'json'

		# Category: Science, Sub: Computers
		response = open('https://opentdb.com/api.php?amount=5&category=18&type=multiple').read
		response = JSON.parse(response)
		if response['response_code'] == 0
			for current in response['results']
				@question = Question.new()
				@question.question = current['question'] 
				@question.firstOption = current['correct_answer'] 
				@question.secondOption = current['incorrect_answers'][0] 
				@question.thirdOption = current['incorrect_answers'][1]
				@question.fourthOption = current['incorrect_answers'][2]
				@question.answer = current['correct_answer'] 
				@question.category = 'Science' 
				@question.subCategory = 'Computers' 
				if Question.where(question: response['question']).first == nil
					@question.save
				end
			end
		end

		
		# Category: Science, Sub: Nature
		response = open('https://opentdb.com/api.php?amount=5&category=17&type=multiple').read
		response = JSON.parse(response)
		if response['response_code'] == 0
			for current in response['results']
				@question = Question.new()
				@question.question = current['question'] 
				@question.firstOption = current['correct_answer'] 
				@question.secondOption = current['incorrect_answers'][0] 
				@question.thirdOption = current['incorrect_answers'][1]
				@question.fourthOption = current['incorrect_answers'][2]
				@question.answer = current['correct_answer'] 
				@question.category = 'Science' 
				@question.subCategory = 'Nature' 
				if Question.where(question: response['question']).first == nil
					@question.save
				end
			end
		end


		# Category: Entertainment, Sub: Television
		response = open('https://opentdb.com/api.php?amount=5&category=14&type=multiple').read
		response = JSON.parse(response)
		if response['response_code'] == 0
			for current in response['results']
				@question = Question.new()
				@question.question = current['question'] 
				@question.firstOption = current['correct_answer'] 
				@question.secondOption = current['incorrect_answers'][0] 
				@question.thirdOption = current['incorrect_answers'][1]
				@question.fourthOption = current['incorrect_answers'][2]
				@question.answer = current['correct_answer'] 
				@question.category = 'Entertainment' 
				@question.subCategory = 'Television' 
				if Question.where(question: response['question']).first == nil
					@question.save
				end
			end
		end


		# Category: Entertainment, Sub: Books
		response = open('https://opentdb.com/api.php?amount=5&category=10&type=multiple').read
		response = JSON.parse(response)
		if response['response_code'] == 0
			for current in response['results']
				@question = Question.new()
				@question.question = current['question'] 
				@question.firstOption = current['correct_answer'] 
				@question.secondOption = current['incorrect_answers'][0] 
				@question.thirdOption = current['incorrect_answers'][1]
				@question.fourthOption = current['incorrect_answers'][2]
				@question.answer = current['correct_answer'] 
				@question.category = 'Entertainment' 
				@question.subCategory = 'Books' 
				if Question.where(question: response['question']).first == nil
					@question.save
				end
			end
		end


		# Category: Entertainment, Sub: Music
		response = open('https://opentdb.com/api.php?amount=5&category=12&type=multiple').read
		response = JSON.parse(response)
		if response['response_code'] == 0
			for current in response['results']
				@question = Question.new()
				@question.question = current['question'] 
				@question.firstOption = current['correct_answer'] 
				@question.secondOption = current['incorrect_answers'][0] 
				@question.thirdOption = current['incorrect_answers'][1]
				@question.fourthOption = current['incorrect_answers'][2]
				@question.answer = current['correct_answer'] 
				@question.category = 'Entertainment' 
				@question.subCategory = 'Music' 
				if Question.where(question: response['question']).first == nil
					@question.save
				end
			end
		end

	end

end