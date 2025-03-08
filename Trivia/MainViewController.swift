//
//  MainViewController.swift
//  Trivia
//
//  Created by Haida, Makouangou on 2025-03-03.
//

import UIKit


class MainViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    
    
    //Var
    let triviaService = TriviaQuestionService()
    var questions: [Question] = []
    var currentQuestionIndex = 0
    var correctAnswers = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateQuestion()
        fetchQuestions()
        initUI()
    }
    
    func fetchQuestions() {
        triviaService.fetchTriviaQuestions { [weak self] questions in
            DispatchQueue.main.async {
                guard let self = self, let questions = questions else { return }
                self.questions = questions
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                self.updateQuestion()
            }
        }
    }
    
    func initUI() {
        let buttons = [option1Button, option2Button, option3Button, option4Button]
        buttons.forEach { $0?.layer.cornerRadius = 5.0 }
        
    }
    
    func updateQuestion() {
        guard currentQuestionIndex < questions.count else {
            showRestartAlert()
            return
        }
        
        let currentQuestion = questions[currentQuestionIndex]
        progressLabel.text = "Question \(currentQuestionIndex + 1) of \(questions.count)"
        questionLabel.text = currentQuestion.text
        categoryLabel.text = currentQuestion.category
        
        let options = currentQuestion.options
        option1Button.setTitle(options[0], for: .normal)
        option2Button.setTitle(options[1], for: .normal)
        option3Button.setTitle(options[2], for: .normal)
        option4Button.setTitle(options[3], for: .normal)
        
        resetButtonStates()
    }
    
    @IBAction func answerSelected(_ sender: UIButton) {
        let correctAnswerIndex = questions[currentQuestionIndex].correctAnswer
        
        if sender.tag == correctAnswerIndex {
            correctAnswers += 1
            sender.backgroundColor = UIColor.green
        } else {
            sender.backgroundColor = UIColor.red
        }
        
        disableButtons()
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.currentQuestionIndex += 1
            self.updateQuestion()
        }
    }
    
    func resetButtonStates() {
        let buttons = [option1Button, option2Button, option3Button, option4Button]
        buttons.forEach {
            $0?.isEnabled = true
            $0?.backgroundColor = UIColor.systemBlue
        }
    }
    
    func disableButtons() {
        let buttons = [option1Button, option2Button, option3Button, option4Button]
        buttons.forEach { $0?.isEnabled = false }
    }
    
    func showRestartAlert() {
        let alert = UIAlertController(title: "Quiz Completed!", message: "You got \(correctAnswers) out of \(questions.count) correct.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            self.restartQuiz()
        }))
        present(alert, animated: true)
    }
    
    func restartQuiz() {
        fetchQuestions()
    }
    
}
