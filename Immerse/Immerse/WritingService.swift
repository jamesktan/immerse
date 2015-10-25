//
//  WritingService.swift
//  Immerse
//
//  Created by James Tan on 10/15/15.
//  Copyright © 2015 Immerse. All rights reserved.
//

import UIKit

class WritingService: NSObject {

  /**
  setup
  1. Find all the bundled files in app
  2. Process each bundled file and record the meta data
  */
  class func setup() {
    
    let processed = RealmService.numberOfObjectsOfType(Writing.self)
    if processed == 0 {
      processWritings()
    } else {
      print("Already Processed")
    }
  }
  
  class func topLevelFolders() -> NSArray {
    let names : NSMutableArray = []
    
    // Get the top level folders
    let path = NSBundle.mainBundle().resourcePath!
    let contents = try! NSFileManager.defaultManager().contentsOfDirectoryAtPath(path)
    for item in contents {
      let items = item.componentsSeparatedByString(" - ")
      if items.count == 2 {
        let castedName =  NSString(string:items.first!)
        if castedName.integerValue < 9 && castedName.integerValue > 0 {
          names.addObject(item)
          print(item)
        }
      }
    }
    
    return NSArray(array: names)
  }
  
  class func isTopLevel(path:String) -> Bool {
    if path.hasPrefix(NSFileManager.localPath()) {
      return false
    } else {
      return true
    }
  }
  
  class func contentsOfSubFolder(folder:String, isTop:Bool = false) -> NSDictionary? {
    
    // Get the Directory
    var folderPath = folder
    if isTop { // If is top level then append the correct path
      folderPath = NSFileManager.localPathForItem(folder)
    }
    
    // Get the Contents of the Folder
    let contents = try! NSFileManager.defaultManager().contentsOfDirectoryAtPath(folderPath)
    if contents.count > 0 {
      
      // Get the Keys
      let keys : NSMutableDictionary = [:]
      for item in contents {
        let itemString = NSString(string: item)
        let itemNameKey = itemString.lastPathComponent.stringByReplacingOccurrencesOfString(".txt", withString: "")
        keys[itemNameKey] = item
      }
      
      return keys
    }
    
    return nil
  }
  
  class func processWritings() {
    
    // Create the Realm Objects
    let items = NSFileManager.defaultManager().recursivePathsForResources(type: "txt")
    for item in items {
      let writing = createWriting(item)
      RealmService.createObject(writing)
    }
    
  }
  
  class func createWriting(path:String) -> Writing {
    let writing = Writing()
    writing.writing_filepath = path
    
    // Get the Title
    let title = NSString(string: path).lastPathComponent.stringByReplacingOccurrencesOfString(".txt", withString: "")
    writing.writing_title = title
    
    // Get ID
    let id = Util.uniqueString()
    writing.writing_id = id
    
    // Author
    // Category
    // Etc.
    // @jtan: Need to standardize the meta data of these docs
    
    return writing
  }
  
}
