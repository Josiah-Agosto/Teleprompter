//
//  MainViewController.swift
//  Teleprompter
//
//  Created by Josiah Agosto on 3/19/19.
//  Copyright © 2019 Josiah Agosto. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    // Outlets
    @IBOutlet weak var textViewOutlet: UITextView!
    @IBOutlet weak var nextButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var textFieldOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // Text View Stuff
        textViewOutlet.delegate = self
        textViewOutlet.layer.cornerRadius = 10
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SecondViewController {
            let destination = segue.destination as! SecondViewController
            destination.recievedText = textViewOutlet.text
            destination.fileName = textFieldOutlet.text!
        }
    }
    
}


// Text View Delegate
extension MainViewController: UITextViewDelegate {
}
