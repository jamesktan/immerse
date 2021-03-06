//
//  Note.swift
//  Immerse
//
//  Created by James Tan on 10/15/15.
//  Copyright © 2015 Immerse. All rights reserved.
//

import RealmSwift

class NoteInterface : GenericModelInterface {

  class func getAllNotes() -> [Note] {
    return RealmService.allObjects(Note.self) as! [Note]
  }
  
  class func createNote(record:Record, range:NSRange, text:String) {
    let note = Note()
    note.record = record
    note.start_position = range.location
    note.length = range.length
    note.note_comment = text
    RealmService.createObject(note)
  }
  
  class func deleteNote(note:Note) {
    RealmService.deleteObject(note)
  }
  
  class func deleteAllNotes() {
    RealmService.deleteObjects(getAllNotes())
  }
  
  class func updateNote(note:Note, text:String) {
    RealmService.updateObject(Note.self, pid: note.id, keys: ["note_comment"], values: [text])
  }
  
}

class Note: Object {

  override static func primaryKey() -> String? {
    return "id"
  }

  dynamic var id : String = String.unique()
  dynamic var record : Record?
  dynamic var start_position : Int = 0
  dynamic var length : Int = 0
  dynamic var note_comment : String = ""
  dynamic var creation_date : NSDate = NSDate()
  
  var recordText : String {
    get {
      let text = record!.record_text as NSString
      let range = NSMakeRange(start_position, length)
      return text.substringWithRange(range)
    }
  }

}
