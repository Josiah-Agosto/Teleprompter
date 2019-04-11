//
//  ContentViewCell.swift
//  Teleprompter
//
//  Created by Josiah Agosto on 4/5/19.
//  Copyright © 2019 Josiah Agosto. All rights reserved.
//

import UIKit

class ContentViewCell: UICollectionViewCell {
    // Outlets
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var playPauseButtonOutlet: UIButton!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    // Variables
    var isPlaying: Bool = false
    // Constants
    let lastVC = LastViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func playPauseButton(_ sender: UIButton) {
        if isPlaying == false && sender.currentTitle == "Play" {
            sender.setTitle("Stop", for: .normal)
            sender.showsTouchWhenHighlighted = true
            lastVC.audioPlayer()
            isPlaying = true
            print("Inside the If Statement")
        } else {
            sender.setTitle("Play", for: .normal)
            isPlaying = false
            sender.showsTouchWhenHighlighted = false
            lastVC.stopRecording()
            print("Inside the Else Statement")
        }
    }
    
    
}
