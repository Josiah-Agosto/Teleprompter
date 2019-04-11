//
//  ViewController.swift
//  Teleprompter
//
//  Created by Josiah Agosto on 3/19/19.
//  Copyright © 2019 Josiah Agosto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    // Outlets
    @IBOutlet weak var finishButtonOutlet: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var fileNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // Text View Stuff
        textView.delegate = self
        textView.layer.cornerRadius = 10
    // Finish Button Stuff
        finishButtonOutlet.layer.cornerRadius = 15
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SecondViewController {
            let destination = segue.destination as! SecondViewController
            destination.recievedText = textView.text
            destination.fileName = fileNameField.text!
        }
    }
    
    // Finish Button
    @IBAction func finishButtonAction(_ sender: UIButton) {
        // Without this, A proper transition won't occur.
        if let destination = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondVC") as? ViewController {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            dismiss(animated: false, completion: nil)
            appDelegate.window?.rootViewController!.present(destination, animated: false, completion: nil)
        }
    }
    
    // Needed to Unwind A View Controller
    @IBAction func unwindSegue(unwinder: UIStoryboardSegue) {
    }

    
}

