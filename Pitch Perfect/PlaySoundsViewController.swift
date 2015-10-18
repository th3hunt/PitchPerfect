//
//  PlaySoundsController.swift
//  Pitch Perfect
//
//  Created by Stratos Pavlakis on 10/4/15.
//  Copyright © 2015 Stratos Pavlakis. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {

    enum PlaySoundsError: ErrorType {
        case PlaybackFailed
    }
    
    var audioPlayer :AVAudioPlayer!
    var recordedAudio :RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: recordedAudio.filePathUrl)
        audioPlayer = try! AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl)
        audioPlayer.enableRate = true
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowSound(sender: UIButton) {
        playAudio(rate: 0.5)
    }

    @IBAction func playFastSound(sender: UIButton) {
        playAudio(rate: 1.5)
    }
    
    @IBAction func playChipmuckSound(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderSound(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopPlayingSound(sender: UIButton) {
        stopAudio()
    }
    
    func stopAudio() {
        stopButton.hidden = true
        audioPlayer.stop()
    }

    func playAudio(rate rate: Float) {
        do {
            
            audioPlayer.stop()
            audioEngine.stop()
            audioPlayer.currentTime = 0.0
            audioPlayer.rate = rate
            if !audioPlayer.play() {
                throw PlaySoundsError.PlaybackFailed
            }
            stopButton.hidden = false
        } catch {
            print("Could not play recording")
            showPlaybackError()
        }
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil) { [unowned self] () in
            self.stopButton.hidden = true
        }
        
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }

    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        stopButton.hidden = true
    }
    
    func showPlaybackError(message: String = "Oops! Could not play your recording") {
        let alertController = UIAlertController(title: "Playback Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(
            UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
                [unowned self] (UIAlertAction) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        )
        presentViewController(alertController, animated: true, completion: nil)
    }
}
