/*
 App        : Assignment 6 – Todo List App - Part 3 – Gesture Control
 Version    : Part 3
 --------------------------
 Group #1
 --------------------------
 Author     : Shirin Mansouri
 Student ID : 301131068
 --------------------------
 Author     : Ali Roudak
 Student ID : 301216533
 --------------------------
 Author     : Walter Edgardo Sancho
 Student ID : 301202813
 --------------------------
 Date       : 11/28/2021
 --------------------------
 Description:
 
 RootViewController handles the logic for the TODO List Scene
 --------------------------
 */

import UIKit
import FirebaseDatabase

class DetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var swIsCompleted: UISwitch!
    @IBOutlet weak var dpDueDate: UIDatePicker!
    @IBOutlet weak var swHasdueDate: UISwitch!
    @IBOutlet weak var lblNote: UITextView!
    @IBOutlet weak var lblTaskName: UITextField!
    @IBOutlet weak var lblTaskTitle: UILabel!
    @IBOutlet weak var taskDetailText: UITextView!
    
    private let database = Database.database().reference()
    let defaults=UserDefaults.standard
    var taskId : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //textView border style
        taskId  =  defaults.string(forKey: "TaskId")!
        taskDetailText!.layer.borderWidth = 1
        taskDetailText!.layer.borderColor = UIColor.lightGray.cgColor
        taskDetailText!.layer.cornerRadius = 6
        loadTask()
       
    }
    
    // edit button functionality
    @IBAction func btnEdit(_ sender: UIButton) {
        let newDueDate : String = DateFormatter.localizedString(from: dpDueDate.date, dateStyle: .medium, timeStyle: .short)
        
        let refreshAlert = UIAlertController(title: "Refresh", message: "Are you Sure to Update the Task ? ", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
             
            self.database.child("ToDoListDatabase").child("TaskList").child(self.taskId).updateChildValues(["name" :  self.lblTaskName.text , "isCompleted" :  self.swIsCompleted.isOn , "notes" : self.lblNote.text,"hasDueDate" : self.swHasdueDate.isOn ,"dueDate" :  newDueDate ])
            self.navigationController?.popViewController(animated: true)
            
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in

        }))

        present(refreshAlert, animated: true, completion: nil)
       
        
        
         
    }
    
    //delete button functionality
    @IBAction func btnDelete(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Refresh", message: "Are you Sure to Delete the Task ? ", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
             
            self.database.child("ToDoListDatabase").child("TaskList").child(self.taskId).removeValue()
            self.navigationController?.popViewController(animated: true)
            
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in

        }))

        present(refreshAlert, animated: true, completion: nil)
       
        
       
    }
  
    //load specific tasck
    private func loadTask()
    {
        
        database.child("ToDoListDatabase").child("TaskList").child(taskId).queryOrderedByKey()
           .observeSingleEvent(of: .value, with: { [self] snapshot in
               guard let lstTasks = snapshot.value as? [String:Any] else {
                   print("Error")
                   return
               }
    
                                
                               lblTaskTitle.text = lstTasks["name"] as!  String
                               lblTaskName.text = lstTasks["name"] as!  String
                               lblNote.text = lstTasks["notes"] as!  String
                               swIsCompleted.isOn = lstTasks["isCompleted"] as! Bool
                               swHasdueDate.isOn = lstTasks["hasDueDate"] as! Bool
                                
                               if(swHasdueDate.isOn == false)
                               {
                                   dpDueDate.isEnabled = false
                               }
                               else
                               {
                                   var strDueDate = lstTasks["dueDate"] as! String
                                   let newString = strDueDate.replacingOccurrences(of: " at", with: ",")
                       
                                  let dateFormatter = DateFormatter()
                                  dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"
                                  dateFormatter.timeZone = NSTimeZone(abbreviation: "EST") as TimeZone?
                                 let dataDate : Date? = dateFormatter.date(from: newString)
                                  dpDueDate.timeZone = TimeZone.init(identifier: "EST")
                                  dpDueDate.date = dataDate!
                               }
                                    
                           
               })
        
        
    }
    
    //cancel button functionality
    @IBAction func btnCancel(_ sender: UIButton) {
        let newDueDate : String = DateFormatter.localizedString(from: dpDueDate.date, dateStyle: .medium, timeStyle: .short)
        
        
        let refreshAlert = UIAlertController(title: "Refresh", message: "Are you Sure to Discard the Changes ? ", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
            
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in

        }))

        present(refreshAlert, animated: true, completion: nil)
       
    }
    
    //determines state of switch due date
    @IBAction func swHasDueDate(_ sender: UISwitch) {
        if(sender.isOn)
        {
            dpDueDate.isEnabled = true
        }
        else
        {
            dpDueDate.isEnabled = false
        }
    }
    
    //hide keyboard tapping anywhere in the view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       }
  
}
