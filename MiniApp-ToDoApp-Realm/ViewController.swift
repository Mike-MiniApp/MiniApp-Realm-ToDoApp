//
//  ViewController.swift
//  MiniApp-ToDoApp-Realm
//
//  Created by 近藤米功 on 2022/04/24.
//

import UIKit
import RealmSwift

class ToDo: Object{
    @objc dynamic var title: String = ""
}

class ViewController: UIViewController{
    var todoItem: Results<ToDo>!

    @IBOutlet var tableView: UITableView!
    @IBOutlet var titleTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        // realmに入っているToDoのデータをtodoItemに入れて更新する
        let realm = try! Realm()
        todoItem = realm.objects(ToDo.self)
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    @IBAction func tappedAddTodoButton(_ sender: Any) {
        // 新しくToDoのインスタンスを作り、realmで保存
        let newTodo = ToDo()
        newTodo.title = titleTextField.text ?? ""
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let object = todoItem[indexPath.row]
        cell.textLabel?.text = object.title
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


}

