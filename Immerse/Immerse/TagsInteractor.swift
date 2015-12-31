//
//  TagsInteractor.swift
//  Immerse
//
//  Created by James Tan on 10/15/15.
//  Copyright © 2015 Immerse. All rights reserved.
//

import UIKit

class TagsInteractor: NSObject {
  weak var presenter : TagsPresenter? = nil
  
  func loadTagMappings() -> NSArray {
    return DataManager.getTagMapping()
  }
}
