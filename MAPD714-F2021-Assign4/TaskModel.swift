//
//  ToDoList.swift
//  ToDoListAssign4
//
//  Created by Shirin Mansouri on 2021-11-08.
//

import Foundation
import UIKit
import FirebaseDatabase
// class for saving and processing our list in the local storage
  class TaskModel
{

    private(set) var name : String
    private(set) var  isCompleted: Bool
    private(set) var notes : String
    private(set) var hasDueDate : Bool
    private(set) var dueDate : String
    private(set) var uuid : String
    private(set) var createDate: String
    
 
    
    init( Name : String , IsCompleted : Bool , Notes : String , HasDueDate : Bool ,
          DueDate : String , Uuid : String, CreateDate : String  )
    {
        self.name = Name;
        self.isCompleted = IsCompleted ;
        self.notes = Notes ;
        self.hasDueDate = HasDueDate ;
        self.dueDate = DueDate;
        self.uuid = Uuid
        self.createDate = CreateDate
        
    }

    /*func updateTask ( taskModel: TaskModel)
    {
        database.child("ToDoListDatabase").updateChildValues([AnyHashable : Any])
        database.child("ToDoListDatabase").child("subNode").updateChildValues(["yourKey": yourValue])
    }*/
}
 
