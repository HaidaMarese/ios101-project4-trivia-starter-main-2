import Foundation

// These are the models
struct TriviaResponse: Decodable {
    let results: [Question]
}

struct Question: Decodable {
    let text: String
    let category: String
    let options: [String]
    let correctAnswer: Int

    enum CodingKeys: String, CodingKey {
        case category, question, correctAnswer = "correct_answer", incorrectAnswers = "incorrect_answers"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        category = try container.decode(String.self, forKey: .category)
        text = try container.decode(String.self, forKey: .question)

        let correct = try container.decode(String.self, forKey: .correctAnswer)
        let incorrect = try container.decode([String].self, forKey: .incorrectAnswers)

        // Combine correct and incorrect answers and shuffle
        var allOptions = incorrect + [correct]
        allOptions.shuffle()

        self.options = allOptions
        self.correctAnswer = allOptions.firstIndex(of: correct) ?? 0
    }
}


