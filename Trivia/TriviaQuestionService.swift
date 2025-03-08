//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Haida, Makouangou on 2025-03-04.
//


import Foundation

class TriviaQuestionService {
    func fetchTriviaQuestions(completion: @escaping ([Question]?) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=5&type=multiple"
        //Check the URL, It is not Nil and it passe to next
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        // fetching the data and parse the data to model
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let triviaResponse = try JSONDecoder().decode(TriviaResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(triviaResponse.results)
                }
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
}
