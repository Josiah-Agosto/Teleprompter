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
    @IBOutlet weak var homeCollectionView: UICollectionView!
    let mainView = ViewController()
    var audioModel = [AudioModel]()
    var fileName: String = ""
    var speechText: String = ""
    var date: String = ""
    var fileURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return UIEdgeInsets(top: CGFloat(inset), left: CGFloat(inset), bottom: CGFloat(inset), right: CGFloat(inset))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataCell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "dataCell", for: indexPath) as! ContentViewCell
        dataCell.layer.borderWidth = 1
        dataCell.layer.cornerRadius = 5
        if let playButton = dataCell.viewWithTag(1) as? UIButton {
            playButton.layer.borderColor = UIColor.green.cgColor
            playButton.layer.cornerRadius = 30
            playButton.layer.borderWidth = 0.5
        }
        let model = audioModel[indexPath.row]
        dataCell.fileNameLabel?.text = model.fileName
        dataCell.dateCreatedLabel?.text = model.dateCreated
        return dataCell
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
