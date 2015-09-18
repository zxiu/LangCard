//
//  ViewController.swift
//  LangStudy
//
//  Created by Zhou Xiu on 11/09/15.
//  Copyright (c) 2015 ZX. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let synthesizer = AVSpeechSynthesizer()
    let sampleUrl = "http://www.123inspiration.com/wp-content/uploads/2012/06/Beautiful-Portraits-by-Viktoria-Stutz-16.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        var image = UIImage(named: "global_intelligence")
        image = DownloadUtil.getImage(sampleUrl)
        self.view.backgroundColor = UIColor(patternImage: image!)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickMenu(sender: UIButton) {
        switch sender.tag{
        case 0:
            goGame(GameMode.Battle)
            break
        case 1:
            goGame(GameMode.Study)
            break
        case 2:
            print("click \(sender.tag)")
            let str = "苹果"
            let utterance = AVSpeechUtterance(string: str)
            utterance.rate = 0.1
            utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
            synthesizer.speakUtterance(utterance)
            break
        default:
            break
        }
        Resource.instance
    }
    
    func goGame(gameMode:GameMode){
        let gameViewControler: GameViewController = self.storyboard?.instantiateViewControllerWithIdentifier("game") as! GameViewController
        gameViewControler.gameMode = gameMode
        let navController = UINavigationController(rootViewController: gameViewControler)
        navController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        navController.modalPresentationStyle = UIModalPresentationStyle.Popover
        presentViewController(navController, animated: true, completion: nil)
    }
    
}

