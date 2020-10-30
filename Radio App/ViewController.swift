//
//  ViewController.swift
//  Radio App
//
//  Created by Md Abdul Awal on 12/23/17.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var gifImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! 
    
    var avPlayer:AVPlayer?
    var avPlayerItem:AVPlayerItem?
    var observer:Any!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()                
        UIApplication.shared.isIdleTimerDisabled = true
        
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "volumeValue") == nil {
            UserDefaults.standard.set(0.5, forKey: "volumeValue")
        }
        
        //set uibutton scale aspect
        playButton.imageView?.contentMode = .scaleAspectFill        
        self.activityIndicator.hidesWhenStopped = true;
        
        //Example URL "http://www.noiseaddicts.com/samples_1w72b820/2514.mp3"
        let urlstring = ""
        let url = NSURL(string: urlstring)
        
        avPlayerItem = AVPlayerItem.init(url: url! as URL)
        avPlayer = AVPlayer.init(playerItem: avPlayerItem)
        avPlayer?.volume = UserDefaults.standard.float(forKey: "volumeValue")
        volumeSlider.value = UserDefaults.standard.float(forKey: "volumeValue")                
        
        self.observer = avPlayer?.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 600), queue: DispatchQueue.main) {
            [weak self] time in           
            if self?.avPlayer?.currentItem?.status == AVPlayerItemStatus.readyToPlay {                
               if(self?.activityIndicator.isAnimating)! {
                 self?.activityIndicator.stopAnimating();
                 self?.gifImage.isHidden = false;
                 self?.gifImage.loadGif(name: "live-logo")
               }
            }
        }       
    }
    
    //Button Actions
    @IBAction func VolumeChanged(_ sender: UISlider) {        
        let currentValue = Float(sender.value)
        avPlayer?.volume = Float(currentValue)
        UserDefaults.standard.set(currentValue, forKey: "volumeValue")
        print(currentValue)
    }
   
    
    
    @IBAction func PlayButtonTapped(_ sender: UIButton) {    
        if avPlayer?.rate == 0{
            self.activityIndicator.startAnimating()
            avPlayer!.play()
            playButton.setImage(UIImage(named: "pause.png"), for: [])         
        } else {           
            self.activityIndicator.stopAnimating();
            gifImage.isHidden = true;
            avPlayer!.pause()
            playButton.setImage(UIImage(named: "play.png"), for: [])
        }       
    }
    
    
    override var shouldAutorotate: Bool {
        return false        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }  
}

