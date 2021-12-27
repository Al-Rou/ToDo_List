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

class RootViewController: UITableViewController {
    
    private var tasks: [TaskModel]! = []
    private var sortedTask : [TaskModel] = []
    private static let taskCell = "Task"
    private var taskModel : TaskModel?
    private var result : [String : Any]?
    private let database = Database.database().reference()
    private var auxCellTag : Int = 0
    
    /* override func viewDidLoad() {
     super.viewDidLoad()
     fillTableView()
     }*/
    
    //fill table when view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tasks = []
        sortedTask = []
        fillTableView()
        
        
    }
    
    //function to add new task
    @IBAction func AddNewTask(_ sender: UIBarButtonItem) {
        
        //create new task - hasDueDate is false and the due date is set with in the distant future
        var object : [String:Any] = ["name" : "New Task", "isCompleted" :  false, "notes" : "","hasDueDate" : false ,"dueDate" : DateFormatter.localizedString(from: Date.distantFuture, dateStyle: .medium, timeStyle: .short) ,"createDate" : DateFormatter.localizedString(from: Date.tomorrow, dateStyle: .medium, timeStyle: .medium) ]
        
        
        database.child("ToDoListDatabase").child("TaskList").child(UUID().uuidString ).setValue(object)
        
        tasks = []
        sortedTask = []
        fillTableView()
    }
    
    //fills the table view
    func fillTableView()
    {
        database.child("ToDoListDatabase").child("TaskList").queryOrderedByKey()
            .observeSingleEvent(of: .value, with: { [self] snapshot in
                guard let lstTasks = snapshot.value as? [String:Any] else {
                    print("Error")
                    return
                }
                lstTasks.forEach { (key, value) in
                    do {
                        var subDict : [String : Any] = value as! [String : Any]
                        var _taskModel : TaskModel
                        _taskModel = TaskModel(Name : subDict["name"] as!  String,IsCompleted : subDict["isCompleted"] as! Bool,Notes : subDict["notes"] as! String ,HasDueDate : subDict["hasDueDate"] as! Bool ,DueDate : subDict["dueDate"] as! String, Uuid : key,CreateDate : subDict["createDate"] as! String)
                        tasks.append(_taskModel)
                    }
                }
                sortTasks()
            })
    }
    
    //returns number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //returns number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTask == nil ? 0 : sortedTask.count
        
    }
    
    //set cell content
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // The TODO List
        let cell = tableView.dequeueReusableCell(withIdentifier: RootViewController.taskCell, for: indexPath)
        
        //set to do task
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
        cell.textLabel?.text = ( sortedTask[indexPath.row] as TaskModel ).name
        
    
        cell.isUserInteractionEnabled = true
        
        
        cell.detailTextLabel?.text = getDetailStatus(dueDate :  ( sortedTask[indexPath.row] as TaskModel ).dueDate, isCompleted: ( sortedTask[indexPath.row] as TaskModel ).isCompleted, hasDueDate: ( sortedTask[indexPath.row] as TaskModel ).hasDueDate)
        if (cell.detailTextLabel?.text == "Completed")
        {
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.textLabel!.text ?? "")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.textLabel?.alpha = 0.4
        }
        else
        {
            cell.textLabel?.alpha = 1
        }
        if (cell.detailTextLabel?.text == "OverDue")
        {
            cell.detailTextLabel?.textColor = .red
        }
        else
        {
            cell.detailTextLabel?.textColor = .black
        }
        if (cell.detailTextLabel?.text == "No due date")
        {
            cell.detailTextLabel?.textColor = .green
        }
        
        
        return cell
    }
    
    //gets the details of each task regarding completion (due date/completed/overdue/no due date)
    private func getDetailStatus(dueDate : String , isCompleted : Bool, hasDueDate : Bool) -> String
    {
        if (isCompleted == true)
        {
            return "Completed"
            
        }
        else if(hasDueDate == true)
        {
            let newString = dueDate.replacingOccurrences(of: " at", with: ",")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "EST") as TimeZone?
            let dataDate : Date? = dateFormatter.date(from: newString)
            if (dataDate! < Date())
            {
                return "OverDue"
            }
            else
            {
                return  dueDate
            }
        }else{
            return "No due date"
        }
    }
    
    // redirect to the detail screen to edit or delete the task
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let defaults=UserDefaults.standard
        let intIndex = indexPath.row // where intIndex < myDictionary.count
        let index = sortedTask.index(sortedTask.startIndex, offsetBy: intIndex)
        defaults.set(sortedTask[index].uuid, forKey: "TaskId")
        
    }
    
    //sort tasks by date of creation
    func sortTasks() {
        sortedTask = tasks.sorted{ $0.createDate > $1.createDate}.sorted{ $1.isCompleted && !$0.isCompleted}
        tableView.reloadData()
        
    }
    
    // function to handle delete and complete tasks
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let defaults=UserDefaults.standard
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            self.database.child("ToDoListDatabase").child("TaskList").child(defaults.string(forKey: "TaskId")!).removeValue()
            self.tasks = []
            self.sortedTask = []
            self.fillTableView()
        }
        let task = sortedTask[indexPath.row]
        let completedTitle = task.isCompleted ? "Mark as incomplete" : "Mark as complete"
        
        let contextItem2 = UIContextualAction(style: .normal, title: completedTitle) { (contextualAction, view, boolValue) in
            //toggle state from complete to incomplete and viceversa
            var toggleState = task.isCompleted
            toggleState.toggle()
            let updateModel : TaskModel = self.sortedTask[indexPath.row] as TaskModel
            self.database.child("ToDoListDatabase").child("TaskList").child(updateModel.uuid).updateChildValues(["name" :  updateModel.name , "isCompleted" :  toggleState , "notes" : updateModel.notes,"hasDueDate" : updateModel.hasDueDate ,"dueDate" :  updateModel.dueDate])
            self.tasks = []
            self.sortedTask = []
            self.fillTableView()
            
        }
        contextItem2.backgroundColor = .systemYellow
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem, contextItem2])

        return swipeActions
    }

    // function to handle edit tasks
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Edit") { (contextualAction, view, boolValue) in
            let detailViewCnt = self.storyboard!.instantiateViewController(withIdentifier: "Detail") as UIViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(detailViewCnt, animated: true)
                
        }
        contextItem.backgroundColor = .systemBlue
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
    
}
