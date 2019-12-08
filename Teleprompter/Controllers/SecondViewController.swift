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
    @IBOutlet weak var textViewOutlet: UITextView!
    // Variables
    var recievedText: String = ""
    var fileName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Text View
        textViewOutlet?.text = recievedText
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LastViewController {
            let destination = segue.destination as! LastViewController
            destination.finishedTextHolder = recievedText
            destination.fileNameText = fileName
        }
    }
    
}
