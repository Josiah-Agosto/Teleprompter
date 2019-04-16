//
//  HomeViewController.swift
//  Teleprompter
//
//  Created by Josiah Agosto on 4/1/19.
//  Copyright © 2019 Josiah Agosto. All rights reserved.
//
// TODO: Fix Transition between Views, Able to Delete Cells in the HomeController Screen, Reload the Items when the Save Button is pressed in the Last Controller, Add a Selected Row at Index Path to allow for changing or Re-Teleprompting the File selected.

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
        if let playButton = dataCell.viewWithTag(1) as? UILabel {
            playButton.layer.borderColor = UIColor.black.cgColor
            playButton.layer.cornerRadius = 5
            playButton.layer.borderWidth = 0.5
        }
        let model = audioModel[indexPath.row]
        dataCell.fileNameLabel?.text = model.fileName
        dataCell.dateCreatedLabel?.text = model.dateCreated
        return dataCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let destination = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectedCell") as? SelectedCellController {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            dismiss(animated: false, completion: nil)
            appDelegate.window?.rootViewController!.present(destination, animated: true, completion: nil)
            let model = audioModel[indexPath.row]
            destination.fileNameLabel?.text = model.fileName
            destination.textView?.text = model.fileText
            destination.fileURL = model.fileURL ?? ""
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


// This allows the URL to be given based on Index Path of the Cell in HomeViewController
extension UIResponder {
    func next<collection: UIResponder>(_ type: collection.Type) -> collection? {
        return next as? collection ?? next?.next(type)
    }
}


// This allows it to be used on the Collection View Cell
extension UICollectionViewCell {
    var collectionView: UICollectionView? {
        return next(UICollectionView.self)
    }
    var indexPath: IndexPath? {
        return collectionView?.indexPath(for: self)
    }
}
