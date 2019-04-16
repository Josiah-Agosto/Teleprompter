//
//  SelectedCellController.swift
//  Teleprompter
//
//  Created by Josiah Agosto on 4/14/19.
//  Copyright © 2019 Josiah Agosto. All rights reserved.
//

import UIKit
import AVFoundation

class SelectedCellController: UIViewController, AVAudioPlayerDelegate {
    // Outlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var playOutlet: UIButton!
    @IBOutlet weak var pauseOutlet: UIButton!
    @IBOutlet weak var stopOutlet: UIButton!
    // Variables
    var fileURL: String = ""
    // Delegates
    var avPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initial Setup
        pauseOutlet.isEnabled = false
        pauseOutlet.layer.opacity = 0.5
        stopOutlet.isEnabled = false
        stopOutlet.layer.opacity = 0.5
    }
    
    
    // Converting the String to a URL
    func convertURL() -> URL {
        let url = URL(fileURLWithPath: fileURL)
        let completedFile = url
        return completedFile
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        if let destination = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            dismiss(animated: false, completion: nil)
            appDelegate?.window?.rootViewController!.present(destination, animated: false, completion: nil)
        }
    }
    
    // Play Button
    @IBAction func playButton(_ sender: UIButton) {
        do {
            avPlayer = try AVAudioPlayer(contentsOf: convertURL())
            avPlayer?.delegate = self
            avPlayer?.play()
            avPlayer?.volume = 1
            // Setup after pressing the Button
            pauseOutlet.isEnabled = true
            pauseOutlet.layer.opacity = 0
            stopOutlet.isEnabled = true
            stopOutlet.layer.opacity = 0
            
        } catch {
            print("Error playing Audio, \(error.localizedDescription)")
        }
    }
    
    // Pause Button
    @IBAction func PauseButton(_ sender: UIButton) {
        if avPlayer?.isPlaying == true {
            avPlayer?.pause()
            // Setip after pressing the Button
            pauseOutlet.isEnabled = false
            pauseOutlet.layer.opacity = 0.5
            playOutlet.isEnabled = true
            stopOutlet.isEnabled = true
        }
    }
    
    // Stop Button
    @IBAction func stopButton(_ sender: UIButton) {
        if avPlayer?.isPlaying == true {
            avPlayer?.stop()
            // Setup after pressing the Button
            stopOutlet.isEnabled = false
            stopOutlet.layer.opacity = 0.5
            playOutlet.isEnabled = false
            playOutlet.layer.opacity = 0.5
            pauseOutlet.isEnabled = false
            pauseOutlet.layer.opacity = 0.5
        }
    }
    
    
}
