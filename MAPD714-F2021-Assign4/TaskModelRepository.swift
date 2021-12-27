//
//  TaskModelRepository.swift
//  MAPD714-F2021-Assign4


import Foundation
import FirebaseDatabase
 public class TaskModelRepository

{    private let database = Database.database().reference()
     
     func addNewTask ( taskModel: TaskModel)
     {
      
         var object : [String:Any] = ["name" :  taskModel.name , "isCompleted" :  taskModel.isCompleted , "notes" : taskModel.notes,"hasDueDate" : taskModel.hasDueDate ,"dueDate" : taskModel.dueDate ]
         
        // var temp : [TaskModel] = [taskModel]
         database.child("ToDoListDatabase").child("TaskList").child(taskModel.uuid).setValue(object)
     }
     func updateTask ( taskModel: TaskModel)
     {
         database.child("ToDoListDatabase").child("TaskList").child(taskModel.uuid).updateChildValues(["name" :  taskModel.name , "isCompleted" :  taskModel.isCompleted , "notes" : taskModel.notes,"hasDueDate" : taskModel.hasDueDate ,"dueDate" : taskModel.dueDate ])
     }
     
      
 }
 
