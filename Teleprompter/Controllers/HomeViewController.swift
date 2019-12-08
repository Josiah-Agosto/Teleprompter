//
//  HomeViewController.swift
//  Teleprompter
//
//  Created by Josiah Agosto on 4/1/19.
//  Copyright © 2019 Josiah Agosto. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    // Outlets
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var newFileOutlet: UIBarButtonItem!
    @IBOutlet weak var editButtonOutlet: UIBarButtonItem!
    // Variables
    var audioModel = [AudioModel]()
    var fileName: String = ""
    var speechText: String = ""
    var date: String = ""
    var fileURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibCell = UINib(nibName: "CustomCell", bundle: nil)
        homeCollectionView.register(nibCell, forCellWithReuseIdentifier: "dataCell")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveData()
        homeCollectionView.reloadData()
    }
    
    
    @IBAction func editButtonAction(_ sender: UIBarButtonItem) {
        customCells()
    }
    

    func customCells() {
        isEditing = !isEditing
        if !isEditing {
            isEditing = false
            newFileOutlet.isEnabled = false
        } else if isEditing {
            isEditing = true
            newFileOutlet.isEnabled = true
        }
    }
    

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
    
} // Class End


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
        return !isEditing ? CGSize(width: 200, height: 200) : CGSize(width: 175, height: 175)
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
        self.navigationController?.pushViewController(destination, animated: true)
    }
} // Extension End
