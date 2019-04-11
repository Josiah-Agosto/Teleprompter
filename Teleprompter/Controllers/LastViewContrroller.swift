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

class LastViewController: UIViewController {
    // Outlets
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var playButtonOutlet: UIButton!
    @IBOutlet weak var pauseButtonOutlet: UIButton!
    @IBOutlet weak var stopButtonOutlet: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
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
    private var avPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
    // Animations and Other Visual Appearances
        pauseButtonOutlet.isEnabled = false
        pauseButtonOutlet.layer.opacity = 0.5
        stopButtonOutlet.isEnabled = false
        stopButtonOutlet.layer.opacity = 0.5
        saveButtonOutlet.isEnabled = false
        saveButtonOutlet.layer.opacity = 0.5
    // Starting to configure the Recording Process
        configure()
    }
    
    
    private func configure() {
        guard let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else {
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
            avRecorder.isMeteringEnabled = true
            avRecorder.prepareToRecord()
        } catch {
            self.timerLabel.text = "Microphone was disabled for this Application."
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
//MARK: Text and UIView and Tapping Screen Functionality Functions
    // Tapping the View; What happens?; It shows each sentence in the Main Section Part, separated by (.), (!), or (?)
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
    
}


// MARK: Audio Extension
extension LastViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
// MARK: AVFoundation Functions
    // Play Button Pressed
    @IBAction func playButton(_ sender: UIButton) {
        recordTapped()
        // Animations and Other Visual Appearances
        sender.layer.opacity = 0.5
        sender.isEnabled = false
        pauseButtonOutlet.isEnabled = true
        pauseButtonOutlet.layer.opacity = 1
        stopButtonOutlet.isEnabled = true
        stopButtonOutlet.layer.opacity = 1
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 1
        isPlaying = true
    }
    
    // Stop Button Pressed
    @IBAction func stopButton(_ sender: UIButton) {
        stopTimer()
        isPlaying = false
        isStillRecording(success: true)
        // Animations and Other Visual Appearances
        sender.layer.opacity = 0.5
        sender.isEnabled = false
        saveButtonOutlet.isEnabled = true
        saveButtonOutlet.layer.opacity = 1
        pauseButtonOutlet.isEnabled = false
        pauseButtonOutlet.layer.opacity = 0.5
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 1
    }
    
    // Pause Pressed
    @IBAction func pauseRecordingButton(_ sender: UIButton) {
        pausingSetup()
        // Animations and Other Visual Appearances
        sender.isEnabled = false
        sender.layer.opacity = 0.5
        stopButtonOutlet.isEnabled = true
        stopButtonOutlet.layer.opacity = 1
        playButtonOutlet.isEnabled = true
        playButtonOutlet.layer.opacity = 1
        view.layer.borderColor = UIColor.yellow.cgColor
        view.layer.borderWidth = 1
    }
    
    // Pausing Recording
    private func pausingSetup() {
        if isPlaying == true {
            playButtonOutlet.setTitle("Play", for: .normal)
            avRecorder.pause()
            isStillRecording(success: false)
            stopTimer()
        }
    }
    
    // Start Recording Function
    private func StartRecording() {
        if isPlaying == false {
            // Recording
            setupRecording()
            startTimer()
            // Changes button when starting to record
            UIView.animate(withDuration: 15, animations: {
                self.playButtonOutlet.layer.opacity = 0.3
            }) { (_) in
                self.playButtonOutlet.layer.opacity = 1
            }
        }
    }
    
    // When finished recording
    private func isStillRecording(success: Bool) {
        if success == true {
            playButtonOutlet.setTitle("Record", for: .normal)
        } else {
            avRecorder.stop()
            avRecorder = nil
            isPlaying = false
            playButtonOutlet.setTitle("Re-Record", for: .normal)
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
            timerLabel.text = "We were unable to Complete the Request."
        }
    }
    
    // Checks if the audio did finish recording and if it did then it will stop
    private func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            let alertMessage = UIAlertController(title: "Finish Recording", message: "Successfully Recorded the Audio.", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alertMessage, animated: true, completion: nil)
        }
    }
    
    // Converts the file path into a URL
    private func getURL() -> URL {
        let filePath = URL(fileURLWithPath: finalURL)
        return filePath
    }
    
    // Used to play the Audio saved by file path
    public func audioPlayer() {
        do {
            avPlayer = try AVAudioPlayer(contentsOf: getURL())
            avPlayer.delegate = self
            avPlayer.prepareToPlay()
            avPlayer.volume = 1.0
        } catch {
            print("Error getting URL, Please Try Again Later, \(error)")
        }
    }
    
    
    public func stopRecording() {
        avPlayer.stop()
    }

// MARK: Timer Functions
    private func startTimer() {
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
            timerLabel.text = "\(minutes):\(seconds)"
        }
    }
    
    // Function to update time
    @objc private func updateTimer() {
        if timer.isValid {
            seconds += 1
            timerLabel.text = "\(minutes):0\(seconds)"
            if seconds >= 10 {
                timerLabel.text = "\(minutes):\(seconds)"
            }
            if seconds == 59 {
                minutes += 1
                seconds = 1
                seconds += 1
            }
        }
    }
    
//MARK: Core Data Methods and IBAction for SaveButton
    @IBAction func saveButton(_ sender: UIButton) {
        saveAudioFiles()
        saveFiles()
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
        // Suppossed to Reload Collection View
    }
    
}
