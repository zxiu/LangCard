//
//  CardView.swift
//  LangStudy
//
//  Created by Zhou Xiu on 15/09/15.
//  Copyright (c) 2015 ZX. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var frontView : UIView!
    var frontImageView : UIImageView!
    var backView : UIImageView!
    var cell : UIView?
    var showingFront = false
    var showingBig = false
    var label : UILabel!
    var entry : Resource.Entry?
    
    var frontImage : UIImage?{
        didSet{
            self.frontImageView.image = self.frontImage
        }
    }
    
    var backImage : UIImage?{
        didSet{
            self.backView.image = self.backImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        frontView = UIView(frame: frame)
        
        frontImageView = UIImageView(frame: frame)
        frontImageView.layer.cornerRadius = 5.0
        frontImageView.backgroundColor = UIColor.whiteColor()
        frontImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        backView = UIImageView(frame: frame)
        backView.layer.cornerRadius = 5.0
        backView.contentMode = UIViewContentMode.ScaleAspectFill
        
        
        label = UILabel(frame:CGRectMake(0, 5, frame.size.width, 20))
        label.textAlignment = NSTextAlignment.Center
        
        frontView.addSubview(frontImageView)
        frontView.addSubview(label)
        
        addSubview(frontView!)
        addSubview(backView!)
         
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

}
