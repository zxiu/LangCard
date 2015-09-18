//
//  Config.swift
//  LangStudy
//
//  Created by Zhou Xiu on 11/09/15.
//  Copyright (c) 2015 ZX. All rights reserved.
//

import Foundation

class Config{
    static let dummyImageUrl = "http://www.dialfredo.com/wp-content/uploads/2015/05/redapplepic.jpg"
    static let instance = Config()
    var categories:[Category] = []
    
    init(){
        let jsonData = NSFileManager.defaultManager().contentsAtPath(NSBundle.mainBundle().resourcePath! + "/config.json")
        let jsonObject = (try? NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.AllowFragments)) as? NSDictionary
        
        print(jsonObject)
        for cateObj in jsonObject?.objectForKey("categories") as! NSArray{
            var category:Category = Category()
            category.name = cateObj.objectForKey("name") as? String
            for entryObj in cateObj.objectForKey("entries") as! NSArray{
                var entry : Entry = Entry()
                entry.name = entryObj.valueForKey("name") as? String
                entry.imageUri = NSURL(string: Config.dummyImageUrl)
                category.entries.append(entry)
                //println(entry)
            }
            print(category)
            categories.append(category)
        }
    }

    
    struct Category: CustomStringConvertible{
        var name:String!
        var imageUri:NSURL!
        var entries:[Entry] = []
        var description: String {
            return "Category name: \(name), entries: \(entries) \n"
        }
    }
    
    
    struct Entry: CustomStringConvertible{
        var name:String!
        var imageUri:NSURL!
        var speechUri:NSURL!
        var voiceUri:NSURL!
        var description: String {
            return "Entry name: \(name), imageUri: \(imageUri) \n"
        }
        
    }
    
}
