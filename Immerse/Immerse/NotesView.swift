//
//  NotesView.swift
//  Immerse
//
//  Created by James Tan on 10/15/15.
//  Copyright © 2015 Immerse. All rights reserved.
//

import UIKit
import KYDrawerController

class NotesView: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet var notesTableView: UITableView!

  @IBOutlet weak var notesToolbar: UIToolbar!
  @IBOutlet weak var editButton: UIBarButtonItem!
  @IBOutlet weak var shareButton: UIBarButtonItem!
  @IBOutlet weak var deleteButton: UIBarButtonItem!
  
  private var sorting : SortOption = SortOption.None
  private var uniqueBooks : [Book] = []
  private var uniqueAuthors : [Author] = []
  private var selectedNotes : [Note] = []
  var noteViewModel : NoteViewModel? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    noteViewModel = NoteViewModel(viewController: self)
    noteViewModel?.setup()
    
    notesTableView.delegate = self
    notesTableView.dataSource = self
    
    let nib = UINib(nibName: "NotesCell", bundle: nil)
    notesTableView.registerNib(nib, forCellReuseIdentifier: "NotesCell")
    notesTableView.tableFooterView = UIView(frame: CGRectZero)

  }

  override func viewWillAppear(animated: Bool) {
    noteViewModel?.setup()
    notesTableView.reloadData()
  }
  //
  
  func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    return UITableViewCellEditingStyle.Insert
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    switch sorting {
    case SortOption.BookAlphabetical:
      return self.uniqueBooks.count
    case SortOption.AuthorAlphabetical:
      return self.uniqueAuthors.count
    default:
      return 1
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch sorting {
    case SortOption.BookAlphabetical:
      let book = self.uniqueBooks[section]
      let sectionBooks = self.noteViewModel!.notes!.filter({
        return ($0.record!.book!.isEqual(book))
      })
      return sectionBooks.count
    case SortOption.AuthorAlphabetical:
      let author = self.uniqueAuthors[section]
      let sectionAuthor = self.noteViewModel!.notes!.filter({
        return ($0.record!.author!.isEqual(author))
      })
      return sectionAuthor.count
    default:
      return noteViewModel!.notes!.count
    }
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("NotesCell") as! NotesCell
    
    switch sorting {
    case SortOption.BookAlphabetical:
      let book = self.uniqueBooks[indexPath.section]
      let sectionBooks = self.noteViewModel!.notes!.filter({
        ($0.record!.book == book)
      })
      let refs = sectionBooks[indexPath.row]
      cell.loadNote(refs)
    case SortOption.AuthorAlphabetical:
      let author = self.uniqueAuthors[indexPath.section]
      let sectionAuthors = self.noteViewModel!.notes!.filter({
        ($0.record!.author == author)
      })
      let refs = sectionAuthors[indexPath.row]
      cell.loadNote(refs)
    default:
      let cross = noteViewModel!.notes![indexPath.row]
      cell.loadNote(cross)
    }
    
    // Select it if it's already selected
    if selectedNotes.contains(cell.note!) {
      cell.setSelected(true, animated: false)
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    switch editingStyle {
    case UITableViewCellEditingStyle.Insert:
      let cell =  tableView.cellForRowAtIndexPath(indexPath) as! NotesCell
      if cell.selected {
        self.selectedNotes.removeObject(cell.note!)
        cell.setSelected(false, animated: true)
      } else {
        self.selectedNotes.append(cell.note!)
        cell.setSelected(true, animated: true)
      }
      updateToolBar()
    default:
      return
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! NotesCell
    let detail = NoteDetailView(nibName: "NoteDetailView", bundle: nil)
    detail.note = cell.note
    self.showViewController(detail, sender: self)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch sorting {
    case SortOption.BookAlphabetical:
      let book = self.uniqueBooks[section]
      return book.name
    case SortOption.AuthorAlphabetical:
      let author = self.uniqueAuthors[section]
      return author.name
    default:
      return nil
    }
  }

  //
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func menuOpen(sender: UIBarButtonItem) {
    if let drawerController = navigationController?.parentViewController as? KYDrawerController {
      drawerController.setDrawerState(.Opened, animated: true)
    }
  }
  
  @IBAction func showSortingOptions(sender: AnyObject) {
    let alert = UIAlertController(title: "Group Cross References By", message: "Select a dimension to group your cross references along.", preferredStyle: .ActionSheet)
    
    let firstAction = UIAlertAction(title: "Writing [A-Z]", style: .Default) { (alert: UIAlertAction!) -> Void in
      self.sorting = SortOption.BookAlphabetical
      
      // Sort the Books
      let books = self.noteViewModel!.notes!.map({$0.record!.book!})
      self.uniqueBooks = NSSet(array: books).allObjects as! [Book]
      self.notesTableView.reloadData()
    }
    
    let secondAction = UIAlertAction(title: "Author [A-Z]", style: .Default) { (alert: UIAlertAction!) -> Void in
      self.sorting = SortOption.AuthorAlphabetical
      
      // Sort the Authors
      let authors = self.noteViewModel!.notes!.map({$0.record!.author!})
      self.uniqueAuthors = NSSet(array: authors).allObjects as! [Author]
      self.notesTableView.reloadData()
    }
    
    
    let thirdAction = UIAlertAction(title: "Recent", style: .Default) { (alert: UIAlertAction!) -> Void in
      self.sorting = SortOption.BookRecent
      self.notesTableView.reloadData()
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
      finished in
      
    })
    
    alert.addAction(firstAction)
    alert.addAction(secondAction)
    alert.addAction(thirdAction)
    alert.addAction(cancel)
    presentViewController(alert, animated: true, completion:nil)
    
  }

  @IBAction func toggleEdit(sender: UIBarButtonItem) {
    if sender.tag == 0 {
      displayToolBar(true)
      self.notesTableView.setEditing(true, animated: true)
      sender.tag = 1
    } else {
      displayToolBar(false)
      self.notesTableView.setEditing(false, animated: true)
      sender.tag = 0
    }
  }
  
  func displayToolBar(show:Bool) {
    if show {
      // Show
      UIView.animateWithDuration(0.3, animations: {
        let correctHeight = self.view.frame.height - 44
        let frame = self.notesToolbar.frame
        self.notesToolbar.frame = CGRectMake(frame.origin.x, correctHeight, frame.width, frame.height)
      })
    } else {
      // Hide
      UIView.animateWithDuration(0.3, animations: {
        let frame = self.notesToolbar.frame
        self.notesToolbar.frame = CGRectMake(frame.origin.x, self.view.frame.height, frame.width, frame.height)
      })
    }
  }
  
  func updateToolBar() {
    // Change the TExt Type
    if self.selectedNotes.count > 0 {
      shareButton.title = "Share"
      deleteButton.title = "Delete"
    } else {
      shareButton.title = "Share All"
      deleteButton.title = "Delete All"
    }
  }
  
  @IBAction func share(sender: AnyObject) {

    if selectedNotes.count > 0 {
      // Selected Notes Are Shared
      let noteText = selectedNotes.map({
        "NOTE: \($0.note_comment)\n" + "FROM: \($0.creation_date)\n" + "\(($0.record!.record_text as NSString).substringWithRange(NSMakeRange($0.start_position, $0.length)))\n\n"
      })
      let final = NSArray(array: noteText).componentsJoinedByString("--------------------")
      shareTextImageAndURL(final)
    } else {
      // All Notes Are Shared
      let noteText = noteViewModel?.notes!.map({
        "NOTE: \($0.note_comment)\n" + "FROM: \($0.creation_date)\n" + "\(($0.record!.record_text as NSString).substringWithRange(NSMakeRange($0.start_position, $0.length)))\n\n"
      })
      let final = NSArray(array: noteText!).componentsJoinedByString("--------------------")
      shareTextImageAndURL(final)
    }

    notesTableView.setEditing(false, animated: true)
    self.selectedNotes.removeAll()
    self.notesTableView.reloadData()
  }
  
  @IBAction func deletePressed(sender: UIBarButtonItem) {
    let control = UIAlertController(title: "Are You Sure?", message: "Delete?", preferredStyle: UIAlertControllerStyle.Alert)
    let delete = UIAlertAction(title: "DELETE", style: UIAlertActionStyle.Destructive, handler: {
      finished in

      if self.selectedNotes.count == 0 {
        // Delete ALl Notes
        self.noteViewModel?.deleteAllNotes()
      } else {
        // Delete Some Notes
        _ = self.selectedNotes.map({
          let note = $0
          self.noteViewModel?.deleteNote(note)
        })
      }
      
      self.noteViewModel?.setup()
      self.notesTableView.reloadData()
      
    })
    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
    control.addAction(delete)
    control.addAction(ok)
    self.presentViewController(control, animated: true, completion: nil)
  }
}
