//
//  SecondViewController.swift
//  Teleprompter
//
//  Created by Josiah Agosto on 3/19/19.
//  Copyright © 2019 Josiah Agosto. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextViewDelegate {
    // Outlets
    @IBOutlet weak var finishedTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButtonFile: UIButton!
    // Variables
    var recievedText: String = ""
    var fileName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Next Button
        nextButton.layer.cornerRadius = 15
        // Back Button
        backButton.layer.cornerRadius = 15
        // Text View
        finishedTextView?.text = recievedText
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LastViewController {
            let destination = segue.destination as! LastViewController
            destination.finishedTextHolder = recievedText
            destination.fileNameText = fileName
        }
    }
    
    
    @IBAction func presentButton(_ sender: UIButton) {
        // Without this, A proper transition won't occur.
        if let destination = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LastVC") as? SecondViewController {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            dismiss(animated: false, completion: nil)
            appDelegate.window?.rootViewController!.present(destination, animated: false, completion: nil)
        }
    }

    
    @IBAction func backButtonAction(_ sender: UIButton) {
        if let destination = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as? SecondViewController {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            dismiss(animated: false, completion: nil)
            delegate.window?.rootViewController!.present(destination, animated: false, completion: nil)
        }
    }
    
    
}
