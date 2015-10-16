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
    private var _rateCardSize : Double = 8.7 / 5.7
    private var _rateCardSpacing : Double = 1.0 / 4.0
    private var _countInRow : Double = 4.0
    private var _cardWidth:Double?
    private var _cardHeight:Double?
    var cardZoomFullRage:CGFloat?
    var center : CGPoint?
    
    init(countInRaw:Int) {
        super.init()
        self._countInRow = Double(countInRaw)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareLayout() {
        super.prepareLayout()
        _collectSize = self.collectionView?.frame.size
        _cellCount = self.collectionView?.numberOfItemsInSection(0)
        print(_collectSize)
        _cardWidth = Double((self.collectionView?.frame.size.width)!) / Double(_countInRow + (_countInRow + 1) * _rateCardSpacing)
        _cardHeight = _cardWidth! * _rateCardSize
        _collectSize?.width
        cardZoomFullRage = CGFloat(Double((_collectSize?.width)!) / Double(_cardWidth!))
        
        center = CGPoint(x: (_collectSize?.width)!/2, y: (_collectSize?.height)!/2)
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
        
        let indexRow = Double(Int(indexPath.item / Int(_countInRow)))
        let indexColumn = Double(indexPath.item) - indexRow * _countInRow
        
        let x = indexColumn * _cardWidth! + (indexColumn + 1) * _cardWidth! * _rateCardSpacing
        let y = indexRow * _cardHeight! + (indexRow + 1) * _cardHeight! * _rateCardSpacing
        
        attrs.frame = CGRect(x: x, y: y, width: _cardWidth!, height: _cardHeight!)
        return attrs
    }
}
