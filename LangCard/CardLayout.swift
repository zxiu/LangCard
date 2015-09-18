//
//  GameCardViewLayout.swift
//  LangStudy
//
//  Created by Zhou Xiu on 14/09/15.
//  Copyright (c) 2015 ZX. All rights reserved.
//

import UIKit

class CardLayout: UICollectionViewLayout {
    private var _cellCount:Int?
    private var _collectSize:CGSize?
    private var _center:CGPoint?
    private var _radius:CGFloat?
    private var _rateCardSize : Double = 8.7 / 5.7
    private var _rateCardSpacing : Double = 1.0 / 4.0
    private var _countHorzizontal : Double = 4.0
    private var _cardWidth:Double?
    private var _cardHeight:Double?
    
    
    
    
    override func prepareLayout() {
        super.prepareLayout()
        _collectSize = self.collectionView?.frame.size
        _cellCount = self.collectionView?.numberOfItemsInSection(0)
        _center = CGPointMake(_collectSize!.width/2, _collectSize!.height/2)
        _radius = min(_collectSize!.width,_collectSize!.height) / 2.5
        
        
        print(_collectSize)
        _cardWidth = Double(_collectSize!.width) / Double(_countHorzizontal + (_countHorzizontal - 1) * _rateCardSpacing)
        _cardHeight = _cardWidth! * _rateCardSize
        
    }
    
    override func collectionViewContentSize() -> CGSize {
        return _collectSize!
    }
   
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = [UICollectionViewLayoutAttributes]()
        if let count = self._cellCount {
            for i in 0 ..< count{                 //这里利用了-layoutAttributesForItemAtIndexPath:来获取attributes
                let indexPath = NSIndexPath(forItem: i, inSection: 0)
                let attributes =  self.layoutAttributesForItemAtIndexPath(indexPath)
                attributesArray.append(attributes!)
            }
        }
        return attributesArray
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        let indexRow = Double(Int(indexPath.item / Int(_countHorzizontal)))
        let indexColumn = Double(indexPath.item) - indexRow * _countHorzizontal
        
        let x = indexColumn * _cardWidth! + (indexColumn) * _cardWidth! * _rateCardSpacing
        let y = indexRow * _cardHeight! + (indexRow) * _cardHeight! * _rateCardSpacing
        
        attrs.frame = CGRect(x: x, y: y, width: _cardWidth!, height: _cardHeight!)
        return attrs
    }
}