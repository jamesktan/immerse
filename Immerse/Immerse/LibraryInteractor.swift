//
//  LibraryInteractor.swift
//  Immerse
//
//  Created by James Tan on 10/15/15.
//  Copyright © 2015 Immerse. All rights reserved.
//

import UIKit

class LibraryInteractor: NSObject {

  var presenter : LibraryPresenter? = nil
  
  func selectWritingNamed(name:String) {
    DataManager.selectWritingByName(name)
  }
  
  func loadFolderMappings() -> NSArray {
  
  }
  
  func childrenForPath(name:String) -> NSArray {
    let matches = DataManager.childrenForPath(name)
    let keys = matches.allKeys
    return keys
  }
}
