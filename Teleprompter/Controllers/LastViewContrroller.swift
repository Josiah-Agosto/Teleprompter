//
//  LastViewContrroller.swift
//  Teleprompter
//
//  Created by Josiah Agosto on 3/19/19.
//  Copyright © 2019 Josiah Agosto. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class LastViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    // Outlets
    @IBOutlet weak var playButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var pauseButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var stopButtonOutlet: UIBarButtonItem!
    lazy var saveBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonAction(_:)))
    @IBOutlet weak var viewHolder: UIView!
    // Text Outlets
    @IBOutlet weak var mainSectionText: UILabel!
    @IBOutlet weak var nextSectionText: UILabel!
    @IBOutlet weak var upcomingSectionText: UILabel!
    // Variables
    private let home = HomeViewController()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var timer = Timer()
    private var seconds: Int = 0
    private var minutes: Int = 0
    var finishedTextHolder: String = ""
    var fileNameText: String = ""
    var finalURL: String = ""
    var dateMade: String = ""
    private var isPlaying: Bool = false
    private var startingShownText: String = ""
    // Button Variables
    private var isPlayEnabled: Bool = true
    private var isPauseEnabled: Bool = false
    private var isStopEnabled: Bool = false
    private var isSaveEnabled: Bool = false
    private var playButtonColor: UIColor {
        return isPlayEnabled ? UIColor.green : UIColor.darkGray
    }
    private var pauseButtonColor: UIColor {
        return isPauseEnabled ? UIColor.yellow : UIColor.darkGray
    }
    private var stopButtonColor: UIColor {
        return isStopEnabled ? UIColor.red : UIColor.darkGray
    }
    private var saveButtonColor: UIColor {
        return isSaveEnabled ? UIColor.white : UIColor.darkGray
    }
    // Variables for TextView
    private var starting: Bool = true
    private var ending: Bool = false
    private var current: Int = 0
    var previous: Int? {
        return current + 1
    }
    var future: Int? {
        return current + 2
    }
    // Delegates
    private var avSession: AVAudioSession!
    private var avRecorder: AVAudioRecorder!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    private func setup() {
        // Navigation Bar
        self.navigationItem.hidesBackButton = true
        let titleColorAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.leftBarButtonItem = saveBarButtonItem
        self.navigationController?.navigationBar.titleTextAttributes = titleColorAttribute
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // Recording Controls
        playButtonOutlet.isEnabled = isPlayEnabled
        pauseButtonOutlet.isEnabled = isPauseEnabled
        stopButtonOutlet.isEnabled = isStopEnabled
        saveBarButtonItem.isEnabled = isSaveEnabled
        // Starting to configure the Recording Process
        configure()
    }
    
    
    private func configure() {
        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            let alertMessage = UIAlertController(title: "Error", message: "Failed to get Document Directory for recording Audio. Please try again Later.", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alertMessage, animated: true, completion: nil)
            return
        }
        let audioFileURL = directoryURL.appendingPathComponent("\(fileNameText).m4a")
        finalURL = audioFileURL.absoluteString
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            // Starts the session if it's successful
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            avRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            avRecorder.delegate = self
            avRecorder.prepareToRecord()
        } catch {
            self.title = "Microphone was disabled for this Application."
        }
    // Opaque Text
    mainSectionText.textColor = UIColor.white
    // View Tapping
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(sender:)))
    viewHolder.addGestureRecognizer(tap)
    }

    // This is used to get the current date and time of the File made
    private func createDateAndTime() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let result = formatter.string(from: Date())
        return result
    }
    
    // Done Button pressed to go back to the previous Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HomeViewController {
            let destination = segue.destination as! HomeViewController
            destination.date = createDateAndTime()
            destination.fileName = fileNameText
            destination.speechText = finishedTextHolder
            destination.fileURL = finalURL
        }
    }

    // MARK: Text View Logic
    @objc private func viewTapped(sender: UITapGestureRecognizer? = nil) {
        var range = [Range<String.Index>]()
        let analyze = finishedTextHolder.linguisticTags(in: finishedTextHolder.startIndex..<finishedTextHolder.endIndex, scheme: NSLinguisticTagScheme.lexicalClass.rawValue, tokenRanges: &range)
        var result = [String]()
        let stuff = analyze.enumerated().filter {
            $0.1 == "SentenceTerminator"
            }.map {range[$0.0].lowerBound}
        var textStart = finishedTextHolder.startIndex
        for sentence in stuff {
            let internalRange = textStart...sentence
            result.append(
                finishedTextHolder[internalRange].trimmingCharacters(
                    in: NSCharacterSet.whitespaces))
            textStart = finishedTextHolder.index(after: sentence)
        }
        let ending: Int = result.count - 2
        mainSectionText.text = result[current]
        nextSectionText.text = result[previous!]
        upcomingSectionText.text = result[future!]
        current += 1
        if current == ending {
            viewHolder.isUserInteractionEnabled = false
        }
    }

    // Play Button Pressed
    @IBAction func playButtonAction(_ sender: UIBarButtonItem) {
        recordTapped()
        isPlayEnabled = false
        sender.isEnabled = isPlayEnabled
        sender.tintColor = playButtonColor
        isPauseEnabled = true
        pauseButtonOutlet.isEnabled = isPauseEnabled
        pauseButtonOutlet.tintColor = pauseButtonColor
        isStopEnabled = true
        stopButtonOutlet.isEnabled = isStopEnabled
        stopButtonOutlet.tintColor = stopButtonColor
        isSaveEnabled = false
        saveBarButtonItem.isEnabled = isSaveEnabled
        saveBarButtonItem.tintColor = saveButtonColor
        isPlaying = true
    }
        
    // Stop Button Pressed
    @IBAction func stopButtonAction(_ sender: UIBarButtonItem) {
        stopTimer()
        isPlaying = false
        isStillRecording(success: true)
        isStopEnabled = false
        sender.isEnabled = isStopEnabled
        sender.tintColor = stopButtonColor
        isPauseEnabled = false
        pauseButtonOutlet.isEnabled = isPauseEnabled
        pauseButtonOutlet.tintColor = pauseButtonColor
        isPlayEnabled = false
        playButtonOutlet.isEnabled = isPlayEnabled
        playButtonOutlet.tintColor = playButtonColor
        isSaveEnabled = true
        saveBarButtonItem.isEnabled = isSaveEnabled
        saveBarButtonItem.tintColor = saveButtonColor
    }
        
    // Pause Pressed
    @IBAction func pauseButtonAction(_ sender: UIBarButtonItem) {
        pausingSetup()
        isPauseEnabled = false
        sender.isEnabled = isPauseEnabled
        sender.tintColor = pauseButtonColor
        isStopEnabled = true
        stopButtonOutlet.isEnabled = isStopEnabled
        stopButtonOutlet.tintColor = stopButtonColor
        isPlayEnabled = true
        playButtonOutlet.isEnabled = isPlayEnabled
        playButtonOutlet.tintColor = playButtonColor
        isSaveEnabled = false
        saveBarButtonItem.isEnabled = isSaveEnabled
        saveBarButtonItem.tintColor = saveButtonColor

    }
        
    // Pausing Recording
    private func pausingSetup() {
        if isPlaying == true {
            avRecorder.pause()
            isStillRecording(success: false)
            stopTimer()
        }
    }
    
    // Start Recording Function
    private func StartRecording() {
        if isPlaying == false {
            setupRecording()
            startTimer()
        }
    }
    
    // When finished recording
    private func isStillRecording(success: Bool) {
        if success == true {
        } else {
            avRecorder.stop()
            avRecorder = nil
            isPlaying = false
        }
    }
    
    // Final Call to Press Play
    @objc private func recordTapped() {
        if avRecorder != nil {
            StartRecording()
        } else {
            isStillRecording(success: false)
        }
    }
    
    // Seting up the Recording
    private func setupRecording() {
        if !avRecorder.isRecording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                avRecorder.record()
            } catch {
                print(error)
            }
        } else {
            isStillRecording(success: false)
            self.title = "We were unable to Complete the Request."
        }
    }
    
    // Checks if the audio did finish recording and if it did then it will stop
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            let alertMessage = UIAlertController(title: "Finish Recording", message: "Successfully Recorded the Audio.", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alertMessage, animated: true, completion: nil)
        }
    }

// MARK: Timer Functions
    private func startTimer() {
        // TODO: Fix the selector
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LastViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    // Stops timer
    private func stopTimer() {
        timer.invalidate()
        restartTimer()
    }
    
    // Restarts Timer
    private func restartTimer() {
        if timer.isValid == false {
            minutes = 0
            seconds = 0
            self.title = "0:00"
        }
    }
    
    // Function to update time
    @objc private func updateTimer() {
        if timer.isValid {
            seconds += 1
            self.title = "\(minutes):0\(seconds)"
            if seconds >= 10 {
                self.title = "\(minutes):\(seconds)"
            }
            if seconds == 59 {
                minutes += 1
                seconds = 0
                seconds += 1
            }
        }
    }
    
//MARK: Core Data Method and Save Method
    @objc private func saveButtonAction(_ sender: UIBarButtonItem) {
        saveAudioFiles()
        saveFiles()
        self.navigationController?.popToRootViewController(animated: true)
//        if let destination = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController {
//            destination.homeCollectionView.reloadData()
//        }
    }

    // Core Data Stuff
    public func saveAudioFiles() {
        let entity = NSEntityDescription.entity(forEntityName: "AudioModel", in: context)
        let newFile = NSManagedObject(entity: entity!, insertInto: context)
        newFile.setValue("\(createDateAndTime())", forKey: "dateCreated")
        newFile.setValue("\(fileNameText)", forKey: "fileName")
        newFile.setValue("\(finishedTextHolder)", forKey: "fileText")
        newFile.setValue("\(finalURL)", forKey: "fileURL")
        home.audioModel.append(newFile as! AudioModel)
    }
    
    // Actually saving Data
    public func saveFiles() {
        do {
            try context.save()
        } catch {
            print("Error saving Context, \(error)")
        }
    }
    
} // Class End



extension LastViewController: CollectionReloadingProtocol {
    func reloadCollection() {
        
    }
}
