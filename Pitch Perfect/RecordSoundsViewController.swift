//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Nekki T on 2015/07/23.
//  Copyright (c) 2015年 next3. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    //####################################################
    // MARK: - Variables
    //####################################################
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    //####################################################
    // MARK: - IBOutlets
    //####################################################
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    //####################################################
    // MARK: - Life Cycle
    //####################################################
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        stopButton.hidden = true
        recordButton.enabled = true
        recordingInProgress.hidden = false
        recordingInProgress.text =  "Tap to Record"
    }
    
    
    //####################################################
    // MARK: - IBActions
    //####################################################
    @IBAction func recordAudio(sender: UIButton) {
        
        recordingInProgress.hidden = false
        recordingInProgress.text = "recording in progress..."
        
        stopButton.hidden = false
        recordButton.enabled = false
        
        //Record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        var recordingName = "my_audio.wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        // Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate  = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
  
    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.hidden = true
        
        // Stop recording the user's voice
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    //####################################################
    // MARK: - AudioRecorder Delegate
    //####################################################
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            //Step 1 - Save the recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            
            
            //Step 2 - Move to the next scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}

