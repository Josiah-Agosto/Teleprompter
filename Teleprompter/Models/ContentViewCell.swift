//
//  ContentViewCell.swift
//  Teleprompter
//
//  Created by Josiah Agosto on 4/5/19.
//  Copyright © 2019 Josiah Agosto. All rights reserved.
//

import UIKit
import AVFoundation

class ContentViewCell: UICollectionViewCell {
    // Delegates
    var avPlayer: AVAudioPlayer!
    // Outlets
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
