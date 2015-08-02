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
    var echoedPlayer: AVAudioPlayer!
    
    let wetDryDegree:Float = 100
    
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
        
        echoedPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
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
    
    // Darth Vader Button Tapped
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    // Echo Button Tapped
    @IBAction func playEchoAudio(sender: UIButton) {
        // first runner
        readyForPlayNew()
        playAudio(1.0)
        
        // echo runner
        let delay:NSTimeInterval = 0.1//100ms
        var playtime:NSTimeInterval
        playtime = echoedPlayer.deviceCurrentTime + delay
        
        echoedPlayer.stop()
        echoedPlayer.currentTime = 0.0
        echoedPlayer.playAtTime(playtime)
    }
    
    // Reverb Button Tapped
    @IBAction func playReverbAudio(sender: UIButton) {
        readyForPlayNew()
        
        var reverb:AVAudioUnitReverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(.LargeHall2)
        reverb.wetDryMix = wetDryDegree
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(reverb)
        
        audioEngine.connect(audioPlayerNode, to: reverb, format: nil)
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: nil)
        
        playWithAudioEngine(audioPlayerNode)
    }
    
    // Stop Button Tapped
    @IBAction func stopAudio(sender: UIButton) {
        readyForPlayNew()
    }
    
    //####################################################
    // MARK: - Local Functions
    //####################################################
    // Play with rate
    func playAudio(rate: Float) {
        readyForPlayNew()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    // Stop and Reset current play
    func readyForPlayNew(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        echoedPlayer.stop()
    }
    
    // Play with Pitch
    func playAudioWithVariablePitch(pitch: Float) {
        readyForPlayNew()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        playWithAudioEngine(audioPlayerNode)
    }
    
    // play node with Audio Engine
    func playWithAudioEngine(audioPlayerNode: AVAudioPlayerNode!) {
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
}
