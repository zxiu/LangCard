//
//  GameViewController.swift
//  LangStudy
//
//  Created by Zhou Xiu on 11/09/15.
//  Copyright (c) 2015 ZX. All rights reserved.
//

import UIKit
import Darwin
import Foundation

extension NSObject{
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}

enum GameMode : String{
    case Battle = "Battle"
    case Study = "Study"
}

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let resource = Resource.instance
    
    var gameMode : GameMode!
    
    
    let countInRow = 4
    let countInColum = 4
    let cardLayout = CardLayout(countInRaw: 4)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(gameMode)
        prepareGame()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "dismiss:")
        navigationItem.title = gameMode.rawValue
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "ViewCell")
        self.collectionView.setCollectionViewLayout(cardLayout, animated: true)
        
        self.view.backgroundColor = UIColor.blueColor()
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
            actionStudy(cardView)
            break
        }
    }
    
    var openedCardViews = Set<CardView>()
    func actionBattle(cardView : CardView, entry:Resource.Entry){
        if (!cardView.showingFront) {
            if openedCardViews.count < 2 {
                UIView.transitionFromView(cardView.backView!, toView: cardView.frontView!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
                cardView.showingFront = true
                openedCardViews.insert(cardView)
            }
            if openedCardViews.count == 2 {
                let cardView1 = openedCardViews.popFirst()
                let cardView2 = openedCardViews.popFirst()
                let result = cardView1?.entry!.name == cardView2?.entry!.name
                if (result){
                    
                }else{
                    self.delay(2.0, closure: { () -> () in
                        self.turnCardBack(cardView1!)
                        self.turnCardBack(cardView2!)
                        }
                    )
                }
            }
        } else {
            UIView.transitionFromView(cardView.frontView!, toView: cardView.backView!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            cardView.showingFront = false
            openedCardViews.remove(cardView)
        }
        print(openedCardViews.count)
    }
    
    func turnCardBack(cardView : CardView){
        UIView.transitionFromView(cardView.frontView!, toView: cardView.backView!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
    }
    
    var oldCenter:CGPoint!
    func actionStudy(cardView : CardView){
        print(cardView.cell!.frame)
        
        if (!cardView.showingBig) {
            if (!cardView.showingFront){
                UIView.transitionFromView(cardView.backView!, toView: cardView.frontView!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
                cardView.showingFront = true
            }
            UIView.animateWithDuration(0.5, animations: {
                cardView.cell!.layer.transform = CATransform3DMakeScale(self.cardLayout.cardZoomFullRage!, self.cardLayout.cardZoomFullRage!, 1)
                self.oldCenter = cardView.cell!.center
                cardView.cell!.center = self.cardLayout.center!
            })
            cardView.showingBig = true
        }else{
            UIView.animateWithDuration(0.5, animations: {
                cardView.cell!.layer.transform = CATransform3DMakeScale(1, 1, 1)
                cardView.cell!.center = self.oldCenter
                
            })
            cardView.showingBig = false
        }
        
        
        
        showDetail(cardView)
        
    }
    
    func showDetail(cardView : CardView){
        SoundUtil.play()
        Speech.talk(cardView.entry!.name, locale: nil)
        
        //        let detailViewControler: DetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detail") as! DetailViewController
        //        let navController = UINavigationController(rootViewController: detailViewControler)
        //        navController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        //        navController.modalPresentationStyle = UIModalPresentationStyle.Popover
        //        presentViewController(navController, animated: true, completion: nil)
        
    }
    
    var categoryIndex:Int = 0
    var currentEntries : [Resource.Entry] = []
    var currentCategory : Resource.Category?
    
    func prepareGame(){
        let randomIndex = Int(arc4random_uniform(UInt32(resource.categories.count)))
        currentCategory = resource.categories[randomIndex]
        
        currentCategory = resource.categories[0]
        var selectedEntries: [Resource.Entry] = []
        for entry in currentCategory!.entries{
            selectedEntries.append(entry)
        }
        switch gameMode!{
        case GameMode.Battle :
            while (selectedEntries.count > countInRow * countInColum / 2){
                let r = Int(arc4random_uniform(UInt32(selectedEntries.count)))
                selectedEntries.removeAtIndex(r)
            }
            for entry in selectedEntries{
                currentEntries.append(entry)
                currentEntries.append(entry)
            }
            break
        case GameMode.Study:
            while (selectedEntries.count > countInRow * countInColum){
                let r = Int(arc4random_uniform(UInt32(selectedEntries.count)))
                selectedEntries.removeAtIndex(r)
            }
            currentEntries = selectedEntries
            break
        }
        
        currentEntries = randomEntrys(currentEntries)
    }
    
    func randomEntrys(var entries:[Resource.Entry]) ->[Resource.Entry]{
        for (var i = 0; i<entries.count; i++){
            let entry = entries[i]
            entries.removeAtIndex(i)
            let r = Int(arc4random_uniform(UInt32(entries.count)))
            entries.insert(entry, atIndex: r)
        }
        return entries
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)-> UICollectionViewCell {
        let identify:String = "ViewCell"
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath)
        let entry = currentEntries[indexPath.item]
        
        let cardView : CardView = CardView(frame: cell.bounds)
        
        cardView.entry = entry
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
