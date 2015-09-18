//
//  GameViewController.swift
//  LangStudy
//
//  Created by Zhou Xiu on 11/09/15.
//  Copyright (c) 2015 ZX. All rights reserved.
//

import UIKit
import Darwin


enum GameMode : String{
    case Battle = "Battle"
    case Study = "Study"
}

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let resource = Resource.instance
    
    var gameMode : GameMode!
    
    var openCardCount = 0
    
    let courses = [
        ["name":"Swift","pic":"redapplepic"],
        ["name":"OC","pic":"oc.jpg"],
        ["name":"Java","pic":"java.png"],
        ["name":"PHP","pic":"php.jpeg"],
        ["name":"JS","pic":"js.jpeg"],
        ["name":"HTML","pic":"html.jpeg"],
        ["name":"Ruby","pic":"ruby.png"]
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(gameMode)
        prepareGame()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "dismiss:")
        navigationItem.title = gameMode.rawValue
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "ViewCell")
        self.collectionView.setCollectionViewLayout(CardLayout(), animated: true)
        
        self.view.backgroundColor = UIColor.blueColor()
        self.collectionView.backgroundColor = UIColor.redColor()
        
    }
    
    func dismiss(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentEntries.count;
    }
    
    func actionCard(sender:UITapGestureRecognizer){
        let cardView : CardView = sender.view as! CardView
        cardView.cell!.superview?.bringSubviewToFront(cardView.cell!)
        let entry = currentEntries[cardView.tag]
        switch (gameMode!){
        case GameMode.Battle:
            actionBattle(cardView, entry: entry)
            break
        case GameMode.Study:
            actionStudy(cardView, entry: entry)
            break
        }
    }
    
    func actionBattle(cardView : CardView, entry:Resource.Entry){
        if (cardView.showingBack) {
            if openCardCount < 2 {
                UIView.transitionFromView(cardView.backView!, toView: cardView.frontView!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
                cardView.showingBack = false
                openCardCount++
            }
            if openCardCount == 2 {
                judgeBattle()
            }
        } else {
            UIView.transitionFromView(cardView.frontView!, toView: cardView.backView!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            cardView.showingBack = true
            openCardCount--
        }
    }
    
    func actionStudy(cardView : CardView, entry:Resource.Entry){
        if (cardView.showingBack) {
            UIView.transitionFromView(cardView.backView!, toView: cardView.frontView!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            cardView.showingBack = false
        }
        
        showDetail(entry)
        
    }
    
    func showDetail(entry:Resource.Entry){
        Speech.talk(entry.name, locale: nil)
//        let detailViewControler: DetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detail") as! DetailViewController
//        let navController = UINavigationController(rootViewController: detailViewControler)
//        navController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
//        navController.modalPresentationStyle = UIModalPresentationStyle.Popover
//        presentViewController(navController, animated: true, completion: nil)
    }
    
    func judgeBattle(){
        
    }
    
    var categoryIndex:Int = 0
    var currentEntries : [Resource.Entry] = []
    func prepareGame(){
        let randomIndex = Int(arc4random_uniform(UInt32(resource.categories.count)))
        currentEntries = resource.categories[randomIndex].entries
        currentEntries = resource.categories[0].entries
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)-> UICollectionViewCell {
        let identify:String = "ViewCell"
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath)
        let entry = currentEntries[indexPath.item]
        
        let cardView : CardView = CardView(frame: cell.bounds)
        
        cardView.tag = indexPath.item
        cardView.frontImage = DownloadUtil.getImage(entry.imageUri)
        cardView.backImage = UIImage(named: "cover_0")
        cardView.label.text = currentEntries[indexPath.item].name
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "actionCard:")
        tapGesture.numberOfTapsRequired = 1
        
        cardView.addGestureRecognizer(tapGesture)
        cardView.userInteractionEnabled = true
        cardView.cell = cell
        cell.addSubview(cardView)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("didSelectItemAtIndexPath")
    }
    
}
