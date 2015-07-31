//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Nekki T on 2015/07/29.
//  Copyright (c) 2015年 next3. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    //####################################################
    // MARK: - Local Variables
    //####################################################
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    //####################################################
    // MARK: - Life Cycle
    //####################################################
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //####################################################
    // MARK: - IBActions
    //####################################################
    // Snail Button Tapped
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(0.5)
    }
    
    // Rabit Button Tapped
    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(1.5)
    }
    
    // Chipmunk Button Tapped
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    
    // Stop Button Tapped
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        
        audioEngine.stop()
        audioEngine.reset()
    }
    
    //####################################################
    // MARK: - Local Functions
    //####################################################
    // Play with rate
    func playAudio(rate: Float) {
        audioPlayer.stop()
        
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    // Play with Pitch
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
}
