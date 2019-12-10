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
    lazy var playBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playButtonAction(_:)))
    lazy var pauseBarButtonItem = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(pauseButtonAction(_:)))
    lazy var stopBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(stopButtonAction(_:)))
    // Variables
    var fileURL: String = ""
    var mainText: String = ""
    var fileName: String? = ""
    // Button Variables
    private var isPlayEnabled: Bool = true
    private var isPauseEnabled: Bool = false
    private var isStopEnabled: Bool = false
    private var playButtonColor: UIColor {
        isPlayEnabled ? UIColor.green : UIColor.clear
    }
    private var pauseButtonColor: UIColor {
        isPauseEnabled ? UIColor.yellow : UIColor.clear
    }
    private var stopButtonColor: UIColor {
        isStopEnabled ? UIColor.red : UIColor.clear
    }
    // Delegates
    var avPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    private func setup() {
        // Navigation Stuff
        self.navigationItem.rightBarButtonItems = [stopBarButtonItem, pauseBarButtonItem, playBarButtonItem]
        playBarButtonItem.isEnabled = isPlayEnabled
        pauseBarButtonItem.isEnabled = isPauseEnabled
        stopBarButtonItem.isEnabled = isStopEnabled
        textView.text = mainText
        self.title = fileName ?? "Unnamed File"
    }
    
    // Converting the String to a URL
    func convertURL() -> URL {
        let url = URL(fileURLWithPath: fileURL)
        let completedFile = url
        return completedFile
    }
    
    // Play Button
    @objc private func playButtonAction(_ sender: UIBarButtonItem) {
        do {
            avPlayer = try AVAudioPlayer(contentsOf: convertURL())
            avPlayer?.delegate = self
            avPlayer?.play()
            avPlayer?.volume = 1
            // Setup after pressing the Button
            sender.isEnabled = true
            sender.tintColor = playButtonColor
            isPauseEnabled = false
            pauseBarButtonItem.tintColor = pauseButtonColor
            isStopEnabled = false
            stopBarButtonItem.tintColor = stopButtonColor
        } catch {
            print("Error playing Audio, \(error.localizedDescription)")
        }
    }
    
    // Pause Button
    @objc private func pauseButtonAction(_ sender: UIBarButtonItem) {
        if avPlayer?.isPlaying == true {
            avPlayer?.pause()
            // Setup after pressing the Button
            sender.isEnabled = true
            sender.tintColor = pauseButtonColor
            isPlayEnabled = false
            playBarButtonItem.tintColor = playButtonColor
            isStopEnabled = false
            stopBarButtonItem.tintColor = stopButtonColor
        } else {
            print("Error Pausing Audio")
        }
    }
    
    // Stop Button
    @objc private func stopButtonAction(_ sender: UIBarButtonItem) {
        if avPlayer?.isPlaying == true {
            avPlayer?.stop()
            // Setup after pressing the Button
            sender.isEnabled = true
            sender.tintColor = stopButtonColor
            isPlayEnabled = false
            playBarButtonItem.tintColor = pauseButtonColor
            isPauseEnabled = false
            pauseBarButtonItem.tintColor = pauseButtonColor
        } else {
            print("Error Stopping Audio")
        }
    }
    
}
