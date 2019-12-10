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
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var editingMarkerLabel: UILabel!
    
    var isInEditingMode: Bool = false {
        didSet {
            editingMarkerLabel.isHidden = !isInEditingMode
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isInEditingMode {
                editingMarkerLabel.layer.cornerRadius = 15
                editingMarkerLabel.layer.borderWidth = 1
                editingMarkerLabel.backgroundColor = isSelected ? UIColor.green : UIColor.clear
            }
        }
    }
}
