//
//  TagViewModel.swift
//  Immerse
//
//  Created by James Tan on 4/10/16.
//  Copyright © 2016 Immerse. All rights reserved.
//

import UIKit

class TagViewModel: GenericViewModel, ViewModelProtocol  {

  var tags : [Tag] = []
  var tagTypes : [TagType] = []
  
  func setup() {
    tagTypes = TagTypeInterface.getAllTagTypes().sort({
      $0.0.name < $0.1.name
    })
    tags = TagInterface.getAllTags()
  }
  
  func getAllTags(type:TagType? = nil) -> [Tag] {
    if type == nil {
      return TagInterface.getAllTags()
    } else {
      return TagInterface.getAllTags().filter({
        return $0.type == type
      })
    }
  }
  
  func createTagType(name:String) -> Bool {
    
    TagTypeInterface.createTag(name)
    
    return true
  }
  
  func createTag(record:Record, range: NSRange, types:[TagType]) {
    _ = types.map({
      TagInterface.createTag(record, range: range, type: $0)
    })
  }
  
  func deleteTag(tag:Tag) {
    TagInterface.deleteTag(tag)
  }
  
  func deleteTags(tagType:TagType) {
    TagInterface.deleteTagsOfType(tagType)
  }
  
  func deleteTagTypeAndTags(tagType:TagType?=nil) {
    TagTypeInterface.deleteTagType(tagType)
    TagInterface.deleteTagsOfType(tagType)
  }
}
