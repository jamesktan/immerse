//
//  TagsView.swift
//  Immerse
//
//  Created by James Tan on 10/15/15.
//  Copyright © 2015 Immerse. All rights reserved.
//

import UIKit
import KYDrawerController
import JCTagListView

class TagsView: UIViewController {

  var edit : Bool = false
  var tagViewModel : TagViewModel? = nil
  
  @IBOutlet var tagListView: JCTagListView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tagViewModel = TagViewModel(viewController: self)
    tagViewModel?.setup()
    
    tagListView.canSelectTags = true
    tagListView.tagCornerRadius = 2.0
    //    self.tagListView.tagStrokeColor = [UIColor redColor];
    //    self.tagListView.tagBackgroundColor = [UIColor orangeColor];
    //    self.tagListView.tagTextColor = [UIColor greenColor];
    //    self.tagListView.tagSelectedBackgroundColor = [UIColor yellowColor];

    if let tagTypes = tagViewModel?.tagTypes {
      let strings = tagTypes.map({$0.name})
      tagListView.tags.addObjectsFromArray(strings)
    }
    tagListView.setCompletionBlockWithSelected({
      finished in
      // On Select
    })
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func menuOpen(sender: UIBarButtonItem) {
    if let drawerController = navigationController?.parentViewController as? KYDrawerController {
      drawerController.setDrawerState(.Opened, animated: true)
    }
  }
  
  func reload() {
  }
  
  @IBAction func editPressed(sender: UIBarButtonItem) {
    if !edit {
      sender.title = "APPLY"
      edit = true
    } else {
      sender.title = "EDIT"
      edit = false
    }
  }
}
