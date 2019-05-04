//
//  HomeViewController.swift
//  Teleprompter
//
//  Created by Josiah Agosto on 4/1/19.
//  Copyright © 2019 Josiah Agosto. All rights reserved.
//
// TODO: Able to Delete Cells in the HomeController Screen, Reload the Items when the Save Button is pressed in the Last Controller.

import UIKit
import CoreData

class HomeViewController: UIViewController {
    // Outlets
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var trashLabel: UILabel!
    @IBOutlet weak var newFileButton: UIButton!
    // Constants
    let mainView = ViewController()
    // Variables
    var audioModel = [AudioModel]()
    var fileName: String = ""
    var speechText: String = ""
    var date: String = ""
    var fileURL: String = ""
    var notEditing: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // Appearances
        trashLabel.layer.opacity = 0
        trashLabel.layer.cornerRadius = 25
    // Instantiating the Nib
        let nibCell = UINib(nibName: "CustomCell", bundle: nil)
        homeCollectionView.register(nibCell, forCellWithReuseIdentifier: "dataCell")
    // Getting the data in Audio Model
        retrieveData()
    }

    
}


// MARK: UICollectionView Extension
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
// MARK: Collection View Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return audioModel.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = 10
        let verticalSpacing = 15
        return UIEdgeInsets(top: CGFloat(verticalSpacing), left: CGFloat(inset), bottom: CGFloat(verticalSpacing), right: CGFloat(inset))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataCell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "dataCell", for: indexPath) as! ContentViewCell
        dataCell.layer.borderWidth = 0.5
        dataCell.layer.cornerRadius = 5
        if let playButton = dataCell.viewWithTag(1) as? UILabel {
            playButton.layer.borderColor = UIColor.black.cgColor
        }
        let model = audioModel[indexPath.row]
        dataCell.fileNameLabel?.text = model.fileName
        dataCell.dateCreatedLabel?.text = model.dateCreated
        return dataCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return !notEditing ? CGSize(width: 200, height: 200) : CGSize(width: 175, height: 175)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let destination = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectedCell") as? SelectedCellController else {
            print("Couldn't find View Controller")
            return
        }
        let model = audioModel[indexPath.row]
        destination.fileName = model.fileName!
        destination.mainText = model.fileText!
        destination.fileURL = model.fileURL!
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        dismiss(animated: false, completion: nil)
        appDelegate?.window?.rootViewController?.present(destination, animated: false, completion: nil)
    }
    
    // Edit Button
    @IBAction func editButtonAction(_ sender: UIButton) {
        customCells()
    }
    
    /// Adds Visual Appearance to Edit Button and Other Objects
    func customCells() {
        notEditing = !notEditing
        if !notEditing {
            notEditing = false
            newFileButton.isEnabled = false
            newFileButton.alpha = 0.5
            UIView.animate(withDuration: 0.7) {
                self.editButton.backgroundColor = UIColor.clear
                self.editButton.setTitleColor(UIColor.red, for: .normal)
                self.trashLabel.layer.opacity = 0
                self.trashLabel.textColor = UIColor.black
            }
        } else if notEditing {
            notEditing = true
            newFileButton.isEnabled = true
            newFileButton.alpha = 1.0
            UIView.animate(withDuration: 0.7) {
                self.editButton.layer.cornerRadius = 5
                self.editButton.setTitleColor(UIColor.white, for: .normal)
                self.editButton.backgroundColor = UIColor.darkGray
                self.trashLabel.layer.opacity = 0.7
                self.trashLabel.layer.backgroundColor = UIColor.red.cgColor
                self.trashLabel.textColor = UIColor.white
            }
        }
    }
// MARK: Persisting data Method
    // Loading the files when the app has been Terminated
    private func retrieveData() {
        // Referring to the App Delegates Container
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        // Creating a Context
        let managedContext = appDelegate.persistentContainer.viewContext
        // What we want to fetch
        let fetchRequest = NSFetchRequest<AudioModel>(entityName: "AudioModel")
        // If i want to sort the Cells by Date
        // fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "dateCreated", ascending: true)]
        do {
            audioModel = try managedContext.fetch(fetchRequest)
        } catch {
            print("Failed to load Data")
        }
    }
    
}
