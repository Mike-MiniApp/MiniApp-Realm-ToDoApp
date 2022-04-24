//
//  ViewController.swift
//  MiniApp-ToDoApp-Realm
//
//  Created by 近藤米功 on 2022/04/24.
//

import UIKit
import RealmSwift
import FSCalendar

class ToDo: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var date: Date? = nil
}
// Date型→String型、String型→Date型のクラス
class DateUtils {
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

class ViewController: UIViewController{
    var todoItem: Results<ToDo>!

    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var titleTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        // realmに入っているToDoのデータをtodoItemに入れて更新する
        let realm = try! Realm()
        todoItem = realm.objects(ToDo.self)
        tableView.reloadData()
        setTableView()
        setCalendar()
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    private func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    private func setCalendar(){
        calendar.delegate = self
        calendar.scope = .week
        calendar.locale = Locale(identifier: "ja")
//        // 現在の国を取得（場所によって現在時刻が変わるため）
//        let calPosition = Calendar.current
//        // 現在の年・月・日・時刻を取得
//        let comp = calPosition.dateComponents(
//            [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,
//             Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second],
//             from: Date())
    }


    @IBAction func tappedAddTodoButton(_ sender: Any) {
        // 新しくToDoのインスタンスを作り、realmで保存
        let newTodo = ToDo()
        newTodo.title = titleTextField.text ?? ""
        newTodo.date = calendar.selectedDate
        let realm = try! Realm()
        try! realm.write{
            realm.add(newTodo)
        }
        print("todoItemのカウント",todoItem.count)
        tableView.reloadData()

    }
}
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItem.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoTableViewCell
        let object = todoItem[indexPath.row]
        cell.textLabel?.text = object.title
        guard let selectedDate = calendar.selectedDate else{
            return cell
        }
        cell.dateLabel.text = DateUtils.stringFromDate(date: selectedDate, format: "yyyy年MM月dd日")
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let realm = try! Realm()
            try! realm.write{
                realm.delete(self.todoItem[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ViewController: FSCalendarDelegate{

}

