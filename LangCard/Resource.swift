//
//  Config.swift
//  LangStudy
//
//  Created by Zhou Xiu on 11/09/15.
//  Copyright (c) 2015 ZX. All rights reserved.
//

import Foundation

class Resource{
    static var isRelease = false
    static var hostRelease = ""
    static var hostDebug = "http://127.0.0.1:3000/"
    static var host : String {
        if isRelease {
            return hostRelease
        }else{
            return hostDebug
        }
    }
    
    static let dummyImageUrl = "http://www.dialfredo.com/wp-content/uploads/2015/05/redapplepic.jpg"
    static let instance = Resource()
    var categories:[Category] = []
    
    init(){
        let jsonData = NSFileManager.defaultManager().contentsAtPath(NSBundle.mainBundle().resourcePath! + "/resource.json")
        let jsonObject = (try? NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.AllowFragments)) as? NSDictionary
        
        print(jsonObject)
        for cateObj in jsonObject?.objectForKey("categories") as! NSArray{
            var category:Category = Category()
            category.name = cateObj.objectForKey("name") as? String
            for entryObj in cateObj.objectForKey("entries") as! NSArray{
                var entry : Entry = Entry()
                entry.name = entryObj as? String
                entry.imageUri = Resource.getEntryImageUrl(entry.name, categoryName: category.name)
                category.entries.append(entry)
            }
            print(category)
            categories.append(category)
        }
    }
    
    static func getEntryImageUrl(entryName:String, categoryName:String) ->String{
        return host + "images/\(categoryName)/\(entryName).jpg"
    }

    
    struct Category: CustomStringConvertible{
        var name:String!
        var imageUri:String!
        var entries:[Entry] = []
        var description: String {
            return "Category name: \(name), entries: \(entries) \n"
        }
    }
    
    
    struct Entry: CustomStringConvertible{
        var name:String!
        var imageUri:String!
        var speechUri:String!
        var voiceUri:String!
        var description: String {
            return "Entry name: \(name), imageUri: \(imageUri) \n"
        }
        
    }
    
}
