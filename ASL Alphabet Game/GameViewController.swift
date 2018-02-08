//
//  GameViewController.swift
//  ASL Alphabet Game
//
//  Created by Jamie Auza on 2/6/18.
//  Copyright © 2018 Jamie Auza. All rights reserved.
//

import UIKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextField!
    @IBOutlet weak var lettersStack: UIStackView!
    
    var score : Int = 0{
        didSet{
            scoreLabel.text! = "Score: \(score)"
        }
    }
    var signImages = [String:String]()
    var commonWords = [String]()
    var randomWordIndex = 0
    var correctAnswer: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if navigationController?.tabBarItem.tag == 1{
            // Get Words
            if let commonWordPath = Bundle.main.path(forResource: "1000_common_words", ofType: "txt"), let commonWordFile = try? String(contentsOfFile: commonWordPath){
                commonWords = commonWordFile.components(separatedBy: "\n")
            }
            
            commonWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: commonWords) as! [String]
        }else{
            answerTextView.placeholder? = "What is the number shown above?"
        }
        
        // Get Images
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for filename in items{
            if filename.hasSuffix(".png"){
                let characters = filename.components(separatedBy: ".")
                signImages.updateValue(filename, forKey: characters[0])
            }
        }
        
        
        showNewWord()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showNewWord(){
        let newAnswer: String?
        if navigationController?.tabBarItem.tag == 1{
            newAnswer = commonWords[randomWordIndex]
            randomWordIndex = (randomWordIndex + 1) % commonWords.count
        }else{
            newAnswer = String(GKRandomSource.sharedRandom().nextInt(upperBound: 9999))
        }
        
        correctAnswer = newAnswer
        for char in correctAnswer{
            let letter = String(char)
            let imageOfSign = UIImage(named: signImages[letter]!)
            let imageView = UIImageView(image: imageOfSign)
            
            lettersStack.addArrangedSubview(imageView)
        }

        lettersStack.axis = .horizontal
        lettersStack.distribution = .fillProportionally
        lettersStack.alignment = .center
        lettersStack.spacing = 5
        lettersStack.translatesAutoresizingMaskIntoConstraints = false
        
        let stackDictionary = ["stack" : lettersStack]
        view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|-[stack]", options: [], metrics: nil, views: stackDictionary))
        view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|-[stack]-|", options: [], metrics: nil, views: stackDictionary))
    }
    
    func resetLetters(alert: UIAlertAction? = nil){
        for subview in lettersStack.arrangedSubviews{
            lettersStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        showNewWord()
    }
    
    @IBAction func submit(_ sender: Any) {
        let userAnswer = answerTextView.text!.lowercased()
        answerTextView.text = ""
        
        if userAnswer == correctAnswer{
            let ac = UIAlertController(title: "Good Job!", message: "\(userAnswer) is the right answer", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: resetLetters))
            score += 1
            present(ac, animated: true)
        }else{
            let ac = UIAlertController(title: "Incorrect!", message: "\(userAnswer) is the not the right answer", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
    
    @IBAction func skip(_ sender: Any) {
        let ac = UIAlertController(title: "Skip", message: "The answer was \(correctAnswer!)", preferredStyle: .alert)
        ac.addAction( UIAlertAction(title: "Continue", style: .default, handler: resetLetters))
        score -= 1
        present(ac, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
