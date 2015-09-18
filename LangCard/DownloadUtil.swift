//
//  DownloadUtil.swift
//  LangStudy
//
//  Created by Zhou Xiu on 16/09/15.
//  Copyright (c) 2015 ZX. All rights reserved.
//

import Foundation
import UIKit
class DownloadUtil{
    private static let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    private static let fileManager = NSFileManager.defaultManager()
    
    private static func loadImageFromNet(url:String) ->UIImage{
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        return UIImage(data: data!)!
    }
    private static func saveImageToLocal(image:UIImage, fileName:String){
        let ext = NSString(string: fileName).pathExtension.lowercaseString
        print(getFullPath(fileName))
        if (ext == "png"){
            UIImagePNGRepresentation(image)!.writeToFile(getFullPath(fileName), atomically: true)
        }else if (ext == "jpg" || ext == "jpeg"){
            UIImageJPEGRepresentation(image, 1.0)!.writeToFile(getFullPath(fileName), atomically: true)
        }
    }
    
    private static func loadImageFromLocal(fileName:String) ->UIImage{
        return UIImage(contentsOfFile: getFullPath(fileName))!
    }
    
    private static func hasImageFromLocal(fileName:String) ->Bool{
        return fileManager.fileExistsAtPath(getFullPath(fileName))
    }
    
    private static func getFullPath(fileName:String) ->String{
        return "\(documentsDirectoryPath)/\(fileName)"
    }
    
    static func getImage(url:String) ->UIImage{
        _ = NSURL(string: url)
        var image : UIImage!
        let fileName = NSString(string: url).lastPathComponent
        print(fileName)
        print(hasImageFromLocal(fileName))
        if (hasImageFromLocal(fileName)){
            image = loadImageFromLocal(fileName)
            print("load from local")
        }else{
            image = loadImageFromNet(url)
            saveImageToLocal(image, fileName: fileName)
            print("load from net")
        }
        return image
    }

    
    /*
    http://code4app.com/snippets/one/%E4%BB%8E%E7%BD%91%E7%BB%9C%E4%B8%8B%E8%BD%BD%E5%9B%BE%E7%89%87-%E4%BF%9D%E5%AD%98-%E5%B9%B6%E7%94%A8-UIImageView-%E4%BB%8E%E4%BF%9D%E5%AD%98%E4%B8%AD%E6%98%BE%E7%A4%BA/511084486803fa9a40000000
    */
    
    
    
}