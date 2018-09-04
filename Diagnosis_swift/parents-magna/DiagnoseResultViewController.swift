//
//  DiagnoseResultViewController.swift
//  parents-magna
//
//  Created by KenichiWatanabe on 2017/05/08.
//  Copyright © 2017年 KenichiWatanabe. All rights reserved.
//

import UIKit
class DiagnoseResultViewController: UIViewController{
    var greatManKey:String = ""
    var big5Score:[String:Float]!
    
    var contentWidth:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBig5score()
        
        let scrollView:UIScrollView = UIScrollView();
        let horizontalInnerMargin:CGFloat = 10.0;
        var totalHeight:CGFloat! = 50
        let greatman:NSDictionary =  loadGreatmen(key:greatManKey)
        contentWidth = self.view.bounds.width
        print("contentWidth",contentWidth)
        
        let nameLabel:UILabel = UILabel()
        nameLabel.text = greatman["name"] as? String
        nameLabel.font = UIFont.systemFont(ofSize:20)
        nameLabel.sizeToFit()
        nameLabel.frame.origin = CGPoint(x:contentWidth*0.1 , y:70)
        nameLabel.backgroundColor = UIColor.green
        scrollView.addSubview(nameLabel);
        
        let bigCatchLabel:UILabel = UILabel()
        bigCatchLabel.text = (greatman["shortDescription"] as! String)
        bigCatchLabel.numberOfLines = 0
        bigCatchLabel.font = UIFont.systemFont(ofSize:18)
        bigCatchLabel.textAlignment = NSTextAlignment.center;

        bigCatchLabel.frame.origin = CGPoint(x:horizontalInnerMargin , y:150)
        bigCatchLabel.frame.size = CGSize(width:contentWidth - horizontalInnerMargin*2, height:100);
        bigCatchLabel.backgroundColor = UIColor.yellow
        bigCatchLabel.textColor =  UIColor(red: 91/255, green: 59/255, blue: 29/255, alpha: 1.0)
        scrollView.addSubview(bigCatchLabel);
        totalHeight = totalHeight + bigCatchLabel.frame.size.height
        
        let smallCatchLabel:UILabel = UILabel()
        smallCatchLabel.text = (greatman["longDescription"] as! String)
        smallCatchLabel.numberOfLines = 0
        smallCatchLabel.textAlignment = NSTextAlignment.left;
        smallCatchLabel.font = UIFont.systemFont(ofSize:16)
        smallCatchLabel.frame.origin = CGPoint(x:horizontalInnerMargin , y:250)
        smallCatchLabel.frame.size = CGSize(width:contentWidth - horizontalInnerMargin * 2, height:200);
        smallCatchLabel.sizeToFit()
        smallCatchLabel.backgroundColor = UIColor.blue
        scrollView.addSubview(smallCatchLabel)
        totalHeight = totalHeight + smallCatchLabel.frame.size.height
        
        
        
        let imageNum:Int = greatman["imageNumber"] as! Int
        let imageName:String = String(imageNum)

        //UIImage作成
        let image:UIImage! = UIImage(named:imageName)
        let imageView: UIImageView = UIImageView(frame: CGRect(
                                                            x:contentWidth/2.5, y:0,
                                                            width:contentWidth/2,height:contentWidth/2))
        imageView.image = image
        scrollView.addSubview(imageView)
        
        //性格スケール
        let scaleView:UIView = makeBig5ScaleSection()
        scaleView.frame.origin = CGPoint(x:horizontalInnerMargin , y:400)
        scrollView.addSubview(scaleView)
        
        self.view.addSubview(scrollView)
        scrollView.frame = self.view.bounds;
        scrollView.contentSize = CGSize(width:contentWidth,  height:800)
        scrollView.backgroundColor = UIColor.red;
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func makeBig5ScaleSection()-> UIView{
        var view:UIView = UIView()
        let viewWidth = contentWidth - 20;
        let offSet:CGFloat = 10
        let distance:CGFloat = 5
//        let width:CGFloat = (contentWidth-offSet * 2 - distance * 4)/5
        let width:CGFloat = (viewWidth-4*offSet)/5
        for j in 0...4{
            var oceanType:String = oceanTypeNameFromIndex( index: j )
            for i in 0...4{
                var colorBlock:UIView = UIView()
                let xPoint:CGFloat = (viewWidth-offSet*2)/5*CGFloat(i)+offSet
                let yPoint:CGFloat = CGFloat(60 * j)
                colorBlock.frame.origin = CGPoint(x: xPoint,  y: yPoint)
                colorBlock.frame.size = CGSize( width:width,   height:20);
                
                var colorBlockLabel:UILabel = UILabel()
                if(i == 2){
                    var displayOceanType:String = oceanTypeDisplayNameFromIndex(index:j)
                    colorBlockLabel.numberOfLines = 1
                    colorBlockLabel.font = UIFont.systemFont(ofSize:10)
                    colorBlockLabel.textAlignment = NSTextAlignment.center;
                    colorBlockLabel.text = displayOceanType
                    colorBlockLabel.frame.origin = CGPoint(x: xPoint,  y: yPoint)
                    colorBlockLabel.frame.size = CGSize( width:width,   height:20);
                }

                switch(j){
                case 0:
                    colorBlock.backgroundColor = UIColor.yellow ;break
                case 1:
                    colorBlock.backgroundColor = UIColor.blue ;break
                case 2:
                    colorBlock.backgroundColor = UIColor.red ;break
                case 3:
                    colorBlock.backgroundColor = UIColor.green ; break
                case 4:
                    colorBlock.backgroundColor = UIColor.purple ;break
                default:break
                }
                let rank:Int = Int(big5Score[oceanType+"Rank"] as! Float)
                if( rank != i){
                    colorBlock.alpha = 0.2
                }
                if(i == 2){
                    view.addSubview(colorBlockLabel)
                }
                view.addSubview(colorBlock)
                
            }
            
            let results: NSArray = loadJson(fileName:"resource/threshold")
            let threshold:NSDictionary = results[j] as! NSDictionary
            let upper:String = threshold["upper"] as! String
            let lower:String = threshold["lower"] as! String
            
            
            let labelY:CGFloat = CGFloat(60 * j)+30
            let upperLabel:UILabel = UILabel()
            upperLabel.text = upper
            upperLabel.font = UIFont.systemFont(ofSize:12)
            upperLabel.sizeToFit()
            upperLabel.frame.size.width = 100
            upperLabel.textAlignment = NSTextAlignment.right
            upperLabel.frame.origin = CGPoint(x:contentWidth-140 , y:labelY)
            view.addSubview(upperLabel);
            
            let lowerLabel:UILabel = UILabel()
            lowerLabel.text = lower
            lowerLabel.font = UIFont.systemFont(ofSize:12)
            lowerLabel.sizeToFit()
            lowerLabel.frame.origin = CGPoint(x:10 , y:labelY)
            view.addSubview(lowerLabel);
        }

        return view
    }
    
    func loadThreshold()->NSArray{
        let results: NSArray = loadJson(fileName:"resource/threshold")
                print(results)
                for result in results {
                    let next = result as! NSDictionary
                    print("======")
                    print(next["oceanType"] as! String)
                    print(next["threshold"] as! NSNumber)
                }
        return results
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
    
    func setBig5score(){
        let results: NSArray = loadJson(fileName:"resource/threshold")
        if(big5Score == nil ){
            big5Score = [:]
            for i in 0...4{
                let threshold:NSDictionary = results[i] as! NSDictionary
                let thresholdScore:Float = threshold["threshold"] as! Float
                
                let p1KeyArray:[String] = greatManKey.characters.map { String($0) }
                let p1 = p1KeyArray[i]
                let oceanType:String = oceanTypeNameFromIndex(index:i)
                print("oceanType=",oceanType)
                print("基準点=",thresholdScore)
                
                big5Score[oceanType]  = p1 == "1" ? thresholdScore + 4.0 : thresholdScore - 4.0
            }
            
        }
        setBig5Rank()
        print(big5Score)
    }
    
    func setBig5Rank(){
        let results: NSArray = loadJson(fileName:"resource/threshold")
        for i in 0...4{
            let threshold:NSDictionary = results[i] as! NSDictionary
            let oceanType:String = threshold["oceanType"] as! String
            let thresholds:[Float] = threshold["five_threshold"] as! [Float]
            print(thresholds)
            
            let score:Float = big5Score[oceanType] as! Float
            big5Score[oceanType+"Rank"] = getOceanScoreRank(ocean:oceanType, score:score)
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
}
