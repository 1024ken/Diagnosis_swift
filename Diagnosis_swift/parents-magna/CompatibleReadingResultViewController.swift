//
//  CompatibleRedingResultViewController.swift
//  parents-magna
//
//  Created by KenichiWatanabe on 2017/05/19.
//  Copyright © 2017年 KenichiWatanabe. All rights reserved.
//

import Foundation
import UIKit

class CompatibleReadingResultViewController: UIViewController {
    @IBOutlet weak var p1GreatManImageView: UIImageView!
    @IBOutlet weak var p2GreatManImageView: UIImageView!
    @IBOutlet weak var p1GreatManNameLabel: UILabel!
    @IBOutlet weak var p2GreatManNameLabel: UILabel!
    @IBOutlet weak var bigCatchLabel: UILabel!
    @IBOutlet weak var smallCatchView: UIScrollView!
    var contentWidth:CGFloat!
    var contentHeight:CGFloat!
    
    var p1greatManKey:String = ""
    var p2greatManKey:String = ""
    
    var p1Greatman:NSDictionary!
    var p2Greatman:NSDictionary!
    var p1Big5Score:[String:Float]!
    var p2Big5Score:[String:Float]!
    let SMALL_CATCH_PAGES:Int = 5;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        smallCatchView.isPagingEnabled = true
        contentWidth = self.view.bounds.width
        contentHeight = smallCatchView.frame.size.height
        smallCatchView.contentSize = CGSize(width:contentWidth * CGFloat(SMALL_CATCH_PAGES),
                                        height: contentHeight)
        
        p1Greatman =  loadGreatmen(key:p1greatManKey)
        p2Greatman =  loadGreatmen(key:p2greatManKey)
        
        loadGreatManImage()
        loadBigCatch()
        setBig5score()
        
        buildSmallCatch()
        
        
    }
    
    
    func buildSmallCatch(){
        for i in 0...4{
            makeContent(pageIndex:i)
        }
    }
    
    func makeContent(pageIndex:Int){
        let view:UIView = UIView()
        view.frame = CGRect(x: smallCatchView.frame.origin.x+contentWidth*CGFloat(pageIndex),
                            y: 0,
                            width:contentWidth, height:contentHeight)
        makeSection(view:view, pageIndex: pageIndex)
        
        smallCatchView.addSubview(view)
    }
    
    func makeSection(view:UIView, pageIndex:Int){
        var oceanType:String = oceanTypeNameFromIndex(index:pageIndex)
        var displayOceanType:String = oceanTypeDisplayNameFromIndex(index:pageIndex)

        let description:String = getSmallCatchDescription(index:pageIndex, oceanType:oceanType)
        let descriptionLabel:UILabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.frame = CGRect(x: view.frame.width*0.05,
                            y: contentHeight*0.4,
                            width:contentWidth*0.9,
                            height:contentHeight*0.6)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        view.addSubview(descriptionLabel);
        
        let oceanTypeLabel:UILabel = UILabel()
        oceanTypeLabel.text = displayOceanType
        oceanTypeLabel.textAlignment = NSTextAlignment.center
        oceanTypeLabel.frame = CGRect(x: view.frame.width*0,
                                        y: 0,
                                        width:contentWidth,
                                        height:contentHeight*0.2)
        view.addSubview(oceanTypeLabel);
        
        let offSet:CGFloat = 20
        let distance:CGFloat = 5
        let width:CGFloat = (contentWidth-offSet * 2 - distance * 4)/5
        for i in 0...4{
            let uiview:UIView = UIView()
            uiview.frame = CGRect(x: (view.frame.width-offSet*2)/5*CGFloat(i)+offSet,
                                          y: 60,
                                          width:width,
                                          height:20)
            switch(pageIndex){
                case 0: uiview.backgroundColor = UIColor.yellow ;break
                case 1: uiview.backgroundColor = UIColor.blue ;break
                case 2: uiview.backgroundColor = UIColor.red ;break
                case 3: uiview.backgroundColor = UIColor.green ;break
                case 4: uiview.backgroundColor = UIColor.purple ;break
            default:break
            }
            view.addSubview(uiview);
        }
        
        let results: NSArray = loadJson(fileName:"resource/threshold")
        let threshold:NSDictionary = results[pageIndex] as! NSDictionary
        let upper:String = threshold["upper"] as! String
        let lower:String = threshold["lower"] as! String
        
        let upperLabel:UILabel = UILabel()
        upperLabel.text = upper
        upperLabel.font = UIFont.systemFont(ofSize:12)
        upperLabel.sizeToFit()
        upperLabel.frame.origin = CGPoint(x:view.frame.width - upperLabel.frame.width-10 , y:80)
        view.addSubview(upperLabel);
        
        let lowerLabel:UILabel = UILabel()
        lowerLabel.text = lower
        lowerLabel.font = UIFont.systemFont(ofSize:12)
        lowerLabel.sizeToFit()
        lowerLabel.frame.origin = CGPoint(x:10 , y:80)
        view.addSubview(lowerLabel);
        
        let p1OceanRank:Float = p1Big5Score[oceanType+"Rank"] as! Float
        let p2OceanRank:Float = p2Big5Score[oceanType+"Rank"] as! Float
        let image1Num:Int = p1Greatman["imageNumber"] as! Int
        let image1Name:String = String(image1Num)
        let image2Num:Int = p2Greatman["imageNumber"] as! Int
        let image2Name:String = String(image2Num)

        let image1:UIImage! = UIImage(named: image1Name)
        let p1Image: UIImageView = UIImageView(frame: CGRect(x:(view.frame.width-offSet*2)/5*CGFloat(p1OceanRank)+offSet-10,
                                                             y:30,width:50,height:50))
        p1Image.image = image1
        view.addSubview(p1Image);
        
        
        let image2:UIImage! = UIImage(named: image2Name)
        let p2Image: UIImageView = UIImageView(frame: CGRect(x:(view.frame.width-offSet*2)/5*CGFloat(p2OceanRank)+offSet + width/2-10,
                                                             y:30,width:50,height:50))
        p2Image.image = image2
        view.addSubview(p2Image);
    }
    
    func setBig5score(){
        let results: NSArray = loadJson(fileName:"resource/threshold")
        if(p1Big5Score == nil && p2Big5Score == nil){
            p1Big5Score = [:]
            p2Big5Score = [:]
            for i in 0...4{
                let threshold:NSDictionary = results[i] as! NSDictionary
                let thresholdScore:Float = threshold["threshold"] as! Float
                
                let p1KeyArray:[String] = p1greatManKey.characters.map { String($0) }
                let p2KeyArray:[String] = p2greatManKey.characters.map { String($0) }
                let p1 = p1KeyArray[i]
                let p2 = p2KeyArray[i]
                let oceanType:String = oceanTypeNameFromIndex(index:i)
                print("oceanType=",oceanType)
                print("基準点=",thresholdScore)

                p1Big5Score[oceanType]  = p1 == "1" ? thresholdScore + 4.0 : thresholdScore - 4.0
                p2Big5Score[oceanType]  = p2 == "1" ? thresholdScore + 4.0 : thresholdScore - 4.0
            }

        }
        setBig5Rank()
        print(p1Big5Score)
        print(p2Big5Score)
        
    
    }
    
    func setBig5Rank(){
        let results: NSArray = loadJson(fileName:"resource/threshold")
        for i in 0...4{
            let threshold:NSDictionary = results[i] as! NSDictionary
            let oceanType:String = threshold["oceanType"] as! String
            let thresholds:[Float] = threshold["five_threshold"] as! [Float]
            print(thresholds)
            
            let p1score:Float = p1Big5Score[oceanType] as! Float
            p1Big5Score[oceanType+"Rank"] = getOceanScoreRank(ocean:oceanType, score:p1score)
            
            let p2score:Float = p2Big5Score[oceanType] as! Float
            p2Big5Score[oceanType+"Rank"] = getOceanScoreRank(ocean:oceanType, score:p2score)
            
        }
    }
    
    func getOceanScoreRank(ocean:String, score:Float)-> Float{
        let results: NSArray = loadJson(fileName:"resource/threshold")
        var rank:Float = -1
        print("=================")
        for i in 0...4{
            let threshold:NSDictionary = results[i] as! NSDictionary
            let oceanType:String = threshold["oceanType"] as! String
            if(ocean == oceanType){
                print("ocean は",ocean)
                print("score は",score)
                let thresholds:[Float] = threshold["five_threshold"] as! [Float]
                print("thresholds は",thresholds)
                if( thresholds[0] <= score &&  score < thresholds[1] ){
                    rank = 0
                }else if( thresholds[1] <= score &&  score < thresholds[2] ){
                    rank = 1
                }else if( thresholds[2] <= score &&  score < thresholds[3] ){
                    rank = 2
                }else if( thresholds[3] <= score &&  score < thresholds[4] ){
                    rank = 3
                }else if( thresholds[4] <= score &&  score < thresholds[5] ){
                    rank = 4
                }
            }
        }
        print("rank は", rank)
        return rank;
    }
    
    func oceanTypeNameFromIndex(index:Int)-> String{
        let results: NSArray = loadJson(fileName:"resource/threshold")
        let data:NSDictionary = results[index] as! NSDictionary
        let type:String = data["oceanType"] as! String
        return type
    }
    
    func oceanTypeDisplayNameFromIndex(index:Int)-> String{
        let results: NSArray = loadJson(fileName:"resource/threshold")
        let data:NSDictionary = results[index] as! NSDictionary
        let type:String = data["displayOceanType"] as! String
        return  type
    }
    
    func loadGreatManImage(){
        let image1Num:Int = p1Greatman["imageNumber"] as! Int
        let image1Name:String = String(image1Num)
        let image2Num:Int = p2Greatman["imageNumber"] as! Int
        let image2Name:String = String(image2Num)
        
        let image1:UIImage! = UIImage(named: image1Name)
        p1GreatManImageView.image = image1
        let image2:UIImage! = UIImage(named: image2Name)
        p2GreatManImageView.image = image2
        
        p1GreatManNameLabel.text = p1Greatman["name"] as? String
        p2GreatManNameLabel.text = p2Greatman["name"] as? String
    }
    
    func loadBigCatch(){
        let data:NSDictionary = loadJson(fileName:"resource/compatibility_diagnosis")[0] as! NSDictionary
        let dict:NSDictionary  = data[p1greatManKey] as! NSDictionary
        let description:String = dict[p2greatManKey] as! String
        bigCatchLabel.text = description
        
    }
    
    func getSmallCatchDescription(index: Int, oceanType:String)-> String{
        let big5data:NSDictionary = loadJson(fileName:"resource/combination_big5")[0] as! NSDictionary
        print(big5data)
        let p1KeyArray:[String] = p1greatManKey.characters.map { String($0) }
        let p2KeyArray:[String] = p2greatManKey.characters.map { String($0) }
        let p1 = p1KeyArray[index]
        let p2 = p2KeyArray[index]
        let suffixP1:String = p1 == "1" ? "High" : "Low"
        let suffixP2:String = p2 == "1" ? "High" : "Low"
        
        let dict:NSDictionary  = big5data[oceanType+suffixP1] as! NSDictionary
        let description:String = dict[oceanType+suffixP2] as! String
        print("oceanType = ",oceanType)
        print("description = ",description)
        return description;
    }
    func loadGreatmen(key:String)->NSDictionary{
        let results:NSArray = loadJson(fileName:"resource/personality_diagnosis")
        let result:NSDictionary = results[0] as! NSDictionary
        return result[key] as! NSDictionary
    }
    func loadJson(fileName:String) -> NSArray{
        print(fileName)
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
