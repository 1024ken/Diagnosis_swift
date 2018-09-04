//
//  TwoColumnsTableViewController.swift
//  parents-magna
//
//  Created by KenichiWatanabe on 2017/05/05.
//  Copyright © 2017年 KenichiWatanabe. All rights reserved.
//

import Foundation
import UIKit
class TwoColumnsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var p1TableView: UITableView!
    @IBOutlet weak var p2TableView: UITableView!
    
    var p1SelectedKey:String = ""
    var p2SelectedKey:String = ""
    
    var greatManData:NSArray!
    override func viewDidLoad() {
        p1TableView.delegate = self
        p1TableView.dataSource = self
        p2TableView.delegate = self
        p2TableView.dataSource = self
        greatManData = loadGreatmen()
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

     func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return greatManData.count
    }

    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let greatMan:NSDictionary = greatManData[indexPath.row]  as! NSDictionary
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell",for: indexPath)
        
        if(tableView.tag == 1 ){
            let greatManNameLabel = cell.viewWithTag(11) as! UILabel
            greatManNameLabel.text = greatMan["name"] as? String
        }else if(tableView.tag == 2 ){
            let greatManNameLabel = cell.viewWithTag(21) as! UILabel
            greatManNameLabel.text = greatMan["name"] as? String
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        let greatMan:NSDictionary = greatManData[indexPath.row]  as! NSDictionary
        
        if(tableView.tag == 1 ){
            print("Table P1", greatMan["name"] as! String)
            p1SelectedKey = greatMan["key"] as! String
        }else if(tableView.tag == 2 ){
            print("Table P2", greatMan["name"] as! String)
            p2SelectedKey = greatMan["key"] as! String
        }
    }
    
    //画面遷移時のvalidation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (p1SelectedKey == "") {
                let alert = UIAlertController(title: "エラー", message: "1人目の偉人スタイルを選択してください", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return false;
        }else if(p2SelectedKey == ""){
            let alert = UIAlertController(title: "エラー", message: "2人目の偉人スタイルを選択してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return false;
        }
        
        return true;
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! CompatibleReadingResultViewController
        viewController.p1greatManKey = p1SelectedKey
        viewController.p2greatManKey = p2SelectedKey
    }
    
    func loadGreatmen()->NSArray{
        let results:NSArray = loadJson(fileName:"resource/greatmenList")
        return results
    }
    
    func loadJson(fileName:String) -> NSArray{
        let path : String = Bundle.main.path(forResource: fileName, ofType: "json")!
        let jsonData = NSData(contentsOfFile: path)
        let data = String(NSString(data: jsonData! as Data, encoding: String.Encoding.utf8.rawValue)!)
        let abe = data.data(using: String.Encoding.utf8)!
        var results: NSArray = []
        do {
            let json = try JSONSerialization.jsonObject(with: abe, options: JSONSerialization.ReadingOptions.allowFragments)
            let top = json as! NSArray // トップレベルが配列
            results = top
        } catch {
            print(error) // パースに失敗したときにエラーを表示
        }
        return results
    }

}

