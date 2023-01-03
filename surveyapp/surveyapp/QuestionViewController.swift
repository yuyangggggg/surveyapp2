//
//  QuestionViewController.swift
//  surveyapp
//
//  Created by YY Tan on 2023-01-03.
//
import UIKit
class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var allQuestions = [Question]()
    var currentQuestion: Question?
    var localAnswers = [Answer]() // stores the answers locally before sending to remote database - index corresponds to question number
    
    @IBOutlet var label: UILabel!
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        setupQuestions()
        configureUI(question: allQuestions.first!)
    }
    
    
    /*
     configures the UI by setting the label text, assigning currentQuestion to the question, and reloads the table to show the answers
     */
    private func configureUI(question: Question) {
        label.text = question.text
        currentQuestion = question
        table.reloadData()
    }
    
    
    /* Saves the answer locally in an array*/
    private func saveAnswerLocally(answer: Answer, question: Question) {
        // saves the answer to a local variable
        localAnswers.append(answer)
    }
    
    /* Creates questions, answers for each question, and appends to allQuestions array that stores all questions.*/
    private func setupQuestions() {
        allQuestions.append(Question(text: "On the scale of 1-5, how fast was the pace of this workshop?", answers: [
            Answer(text: "1 - too slow"),
            Answer(text: "2 - slow"),
            Answer(text: "3 - just right"),
            Answer(text: "4 - fast"),
            Answer(text: "5 -  too fast")
        ]))
        allQuestions.append(Question(text: "On a scale of 1-5, how likely are you to implement a survey app like this on your own?", answers: [
            Answer(text: "1 - very unlikely"),
            Answer(text: "2 - unlikely"),
            Answer(text: "3 - maybe"),
            Answer(text: "4 - likely"),
            Answer(text: "5 - very likely")
        
        ]))
        allQuestions.append(Question(text: "Would you recommend this workshop to others?", answers: [
            Answer(text: "Yes"),
            Answer(text: "No")
        ]))
        // one question that involves a text label?
    }
    
    // tableview functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestion?.answers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath )
        cell.textLabel?.text = currentQuestion?.answers[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let question = currentQuestion else {
            return
        }
        let answer = question.answers[indexPath.row]
        
        if let index = allQuestions.firstIndex(where: {$0.text == question.text}) {
            if index < (allQuestions.count - 1) {
                // next question
                saveAnswerLocally(answer: answer, question: question)
                let nextQuestion = allQuestions[index + 1]
                configureUI(question: nextQuestion)
                table.reloadData()
            } else {
                // end the survey
                saveAnswerLocally(answer: answer, question: question)
                // save the local answers to the remote database
                let alert = UIAlertController(title: "Survey completed", message: "Thank you for completing the survey. Your responses have been recorded :)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                present(alert, animated: true)
                }
            }
    }
}

struct Question {
    var text: String
    var answers: [Answer]
}

struct Answer {
    var text: String
}
