//
//  LibraryPresenter.swift
//  Immerse
//
//  Created by James Tan on 10/15/15.
//  Copyright © 2015 Immerse. All rights reserved.
//

import UIKit

class LibraryPresenter: NSObject {

  static let sharedInstance : LibraryPresenter = LibraryPresenter()
  var view : LibraryView? = nil
  var interactor : LibraryInteractor? = nil
  
  var isSetup : Bool = false
  var topLevel : NSArray = []
  var mapping : NSMutableDictionary = [:]
  func setup() {
    if !isSetup {
      topLevel = (interactor?.getTopLevelFolders())!
      isSetup = true
    }
  }
  
  func cellForRow(tableView:UITableView, indexPath:NSIndexPath) -> UITableViewCell {
    let section = indexPath.section
    let sectionName = topLevel.objectAtIndex(section)
    let list = mapping.objectForKey(sectionName)
    
    var title = "Hello"
    if indexPath.row < list!.count {
      title = (list?.objectAtIndex(indexPath.row))! as! String
    }
    let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("LibraryCell", forIndexPath: indexPath)
    cell.textLabel!.text = title
    return cell
  }
  
  func numberOfSections() -> Int {
    return topLevel.count
  }
  
  func titleForSection(section:Int) -> String {
    return topLevel.objectAtIndex(section) as! String
  }
  func numberOfRowsForSection(section:Int) -> Int {
    let name = topLevel.objectAtIndex(section) as! String
    let children = interactor?.childrenForPath(name )
    mapping[name] = children
    return children!.count
  }
}
