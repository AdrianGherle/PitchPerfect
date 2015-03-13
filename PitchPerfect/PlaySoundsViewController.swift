//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Adrian Gherle on 3/13/15.
//  Copyright (c) 2015 Adrian Gherle. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var player: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        player = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        player.enableRate = true
        player.prepareToPlay()
        
        //        // this set of code plays a file that is in the resouce files of the app (hard coded)
        //        let mainBundle = NSBundle.mainBundle()
        //        let filePath = mainBundle.pathForResource("movie_quote", ofType: "mp3")
        //
        //        if let path = NSURL(fileURLWithPath: filePath!) {
        //            player = AVAudioPlayer(contentsOfURL: path, error: nil)
        //            player!.enableRate = true
        //            player!.prepareToPlay()
        //        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBAction
    @IBAction func slowPlay(sender: UIButton) {
        player!.stop()
        audioEngine.stop()
        player!.rate = 0.5
        player!.currentTime = 0.0
        player!.play()
    }
    
    @IBAction func fastPlay(sender: UIButton) {
        player!.stop()
        audioEngine.stop()
        player!.rate = 2.0
        player!.currentTime = 0.0
        player!.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
  
    @IBAction func stopPlay(sender: UIButton) {
        player!.stop()
        audioEngine.stop()
    }
    
    //MARK: Local Functions
    func playAudioWithVariablePitch(pitch: Float) {
        audioEngine.stop()
        audioEngine.reset()
        player.stop()
        
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
