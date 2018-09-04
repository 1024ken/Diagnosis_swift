//
//  GreatManListView.swift
//  parents-magna
//
//  Created by KenichiWatanabe on 2017/05/06.
//  Copyright © 2017年 KenichiWatanabe. All rights reserved.
//

import Foundation
import UIKit

class GreatManListViewController: UITableViewController{
    
    var selectedGreatManKey:String = ""
    var greatManData:NSArray!
    override func viewDidLoad() {
        greatManData = loadGreatmen()
    }
    
    //Table Viewのセクションの数を指定
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    //Table Viewのセルの数を指定
    override func tableView(_ table: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return greatManData.count
    }
    
    //各セルの要素を設定する
    override func tableView(_ table: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let greatMan:NSDictionary = greatManData[indexPath.row]  as! NSDictionary
        let cell = table.dequeueReusableCell(withIdentifier: "tableCell",
                                             for: indexPath)
        
        let rowNumberLabel = cell.viewWithTag(1) as! UILabel
        rowNumberLabel.text = "No." + String(indexPath.row + 1)
        
        let greatManNameLabel = cell.viewWithTag(2) as! UILabel
        greatManNameLabel.text = greatMan["name"] as? String

        let imageNum:Int = greatMan["imageNumber"] as! Int
        let imageName:String = String(imageNum)
        let image:UIImage! = UIImage(named:imageName)
        let imageView = cell.viewWithTag(3) as! UIImageView
        imageView.image = image
        
        return cell
    }
    
    // Cell の高さを１２０にする
    override func tableView(_ table: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        let greatMan:NSDictionary = greatManData[indexPath.row]  as! NSDictionary
        selectedGreatManKey = greatMan["key"] as! String
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        performSegue(withIdentifier: "showDiagnoseResult", sender: Any?.self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! DiagnoseResultViewController
        viewController.greatManKey = selectedGreatManKey
    }
    
    func loadGreatmen()->NSArray{
        let results:NSArray = loadJson(fileName:"resource/greatmenList")
        let result:NSDictionary = results[0] as! NSDictionary
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
