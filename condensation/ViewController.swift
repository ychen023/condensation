//
//  ViewController.swift
//  condensation
//
//  Created by Yilin Chen on 5/24/22.
//

import UIKit

class ViewController: UIViewController {
    
    var urlString = UserDefaults.standard.string(forKey: "quizquestionsurl") ?? "https://tednewardsandbox.site44.com/questions.json"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    fileprivate func getData() {
        guard let url = URL.init(string: urlString) else {
            return
        }
        let session = URLSession.shared.dataTask(with: url) {data, response, error in
            if response != nil {
                if (response! as! HTTPURLResponse).statusCode != 200 {
                    let archiveURL = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/scores.archive")
                    let readScores = NSArray(contentsOf: archiveURL)
                    TableDataAndDelegate.data = readScores as! [Subject]
                } else {
                    do {
                        TableDataAndDelegate.data = []
                        let questions =  try JSONSerialization.jsonObject(with: data!) as! NSArray
                        DispatchQueue.main.async {
                            for i in 0..<questions.count {
                                let object = questions[i] as! NSDictionary
                                let objectQuestions = object["questions"]! as! NSArray
                                var QuestionArray : [Question] = []
                                for i in 0..<objectQuestions.count {
                                    let oneQuestion = objectQuestions[i] as! NSDictionary
                                    QuestionArray.append(
                                        Question(
                                            text: oneQuestion["text"] as! String,
                                            answer: oneQuestion["answer"] as! String,
                                            answers: oneQuestion["answers"] as! [String]
                                        )
                                    )
                                }
                                TableDataAndDelegate.data.append(Subject(
                                    subj: object["title"]! as! String,
                                    desc: object["desc"]! as! String,
                                    question: QuestionArray
                                ))
                            }
                            self.SubjectsTableView.reloadData()
                            print(TableDataAndDelegate.data)
                            print(self.urlString)
                            
                            // UNSURE IF DATA ACTUALLY SAVES
                            let archivePath = NSHomeDirectory() + "/Documents/quizzes.archive"
                            print(archivePath)
                            let quizArchive = TableDataAndDelegate.data as NSArray
                            print(quizArchive)
                            quizArchive.write(toFile: archivePath, atomically: true)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            print("something went wrong")
                            self.showError()
                        }
                    }
                }
            }
        }
        session.resume()
    }
    

}

