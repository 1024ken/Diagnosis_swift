//
//  DiagnoseViewController.swift
//  parents-magna
//
//  Created by KenichiWatanabe on 2017/05/04.
//  Copyright © 2017年 KenichiWatanabe. All rights reserved.
//

import UIKit
class DiagnoseViewController: UIViewController{

    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var questions:NSArray = []
    
    var contentWidth:CGFloat!
    var contentHeight:CGFloat!
    
    var buttonEventAvailabled:Bool = true
    var answers:[Int]!
    
    var greatManKey:String = ""
    var big5Score:[String:Float] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressLabel.text = "0/40"
        answers = [0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0]
        progressBar.progress = 0
        progressBar.transform = CGAffineTransform(scaleX: 1.0, y: 6.0)
        
        questions = loadQuestions()
        scrollView.isPagingEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        contentWidth = self.view.bounds.width
        contentHeight = scrollView.frame.size.height
        scrollView.contentSize = CGSize(width:contentWidth*8,
                                        height: contentHeight)
        
        buildQuestionScrollView()
    }
    
    func buildQuestionScrollView(){
        for i in 0...7{
            makeContent(pageIndex:i)
        }
    }
    
    func makeContent(pageIndex:Int){
        let view:UIView = UIView()
        view.frame = CGRect(x: scrollView.frame.origin.x+contentWidth*CGFloat(pageIndex),
                                y: 0,
                                width:contentWidth, height:contentHeight)
//        view.backgroundColor = UIColor.green
        for i in 0...4{
            let section:UIView = makeSection(pageIndex: pageIndex, sectionIndex:i)
            view.addSubview(section)
        }
        
        scrollView.addSubview(view)
    }
    
    func makeSection(pageIndex:Int, sectionIndex:Int) -> UIView{
        let questionIndex:Int = (pageIndex*5) + sectionIndex
        let question = questions[questionIndex] as! NSDictionary

        let questionText:String = question["text"] as! String;
        let viewWidth:CGFloat  = contentWidth*0.9;
        let viewHeight:CGFloat  = contentHeight/7;
        
        let view = UIView()
        view.frame = CGRect(x: viewWidth*0.05,  y: 10+CGFloat(viewHeight+10)*CGFloat(sectionIndex),
                                width:viewWidth, height:viewHeight)
        view.backgroundColor = UIColor.init(red: 255/255, green: 182/255, blue: 193/255, alpha: 1.0)
        let label:UILabel = UILabel()
        label.frame = CGRect(x: 0,  y: 0,
                             width: view.frame.size.width, height: 40)
        label.text = questionText
        label.font = UIFont.systemFont(ofSize:16)
        label.numberOfLines = 2
        view.addSubview(label)
        
        
        //回答ボタン配置
        let noButton = UIButton()
        noButton.frame = CGRect(x:  0,
                                                        y: view.frame.size.height*0.5,
                                                        width: 60, height: 40)
        noButton.setTitle("いいえ", for: .normal)
        noButton.setTitleColor(UIColor.blue, for: .highlighted)
        noButton.tag = pageIndex*100 + sectionIndex*10 + 1
        noButton.addTarget(self, action: #selector(buttonEvent(sender:)), for: .touchUpInside)
        view.addSubview(noButton)
        
        let neitherButton = UIButton()
        neitherButton.frame = CGRect(x:  view.frame.size.width*0.3,
                                 y: view.frame.size.height*0.5,
                                 width: 120, height: 40)
        neitherButton.setTitle("どちらでもない", for: .normal)
        neitherButton.setTitleColor(UIColor.blue, for: .highlighted)
        neitherButton.tag = pageIndex*100 + sectionIndex*10 + 2
        neitherButton.addTarget(self, action: #selector(buttonEvent(sender:)), for: .touchUpInside)
        view.addSubview(neitherButton)
        
        let yesButton = UIButton()
        yesButton.frame = CGRect(x:  view.frame.size.width*0.8,
                                     y: view.frame.size.height*0.5,
                                     width: 40, height: 40)
        yesButton.setTitle("はい", for: .normal)
        yesButton.setTitleColor(UIColor.blue, for: .highlighted)
        yesButton.tag = pageIndex*100 + sectionIndex*10 + 3
        yesButton.addTarget(self, action: #selector(buttonEvent(sender:)), for: .touchUpInside)
        view.addSubview(yesButton)
        
        
        return view
    }
    
    func buttonEvent(sender: UIButton) {
        if(!buttonEventAvailabled){
            return
        }
        buttonEventAvailabled = false
        sender.isEnabled = false

        let tag:Int = sender.tag
        print("tag ", tag)
        let tens:Int = Int(floor(Float(tag)/10.0))
        var noButton: UIButton = self.view.viewWithTag(tens*10+1) as! UIButton
        noButton.setTitleColor(UIColor.white, for: .normal)
        var neighterButton: UIButton = self.view.viewWithTag(tens*10+2) as! UIButton
        neighterButton.setTitleColor(UIColor.white, for: .normal)
        var yesButton: UIButton = self.view.viewWithTag(tens*10+3) as! UIButton
        yesButton.setTitleColor(UIColor.white, for: .normal)
        
        sender.setTitleColor(UIColor.blue, for: .normal)
        
        let tensA:Int = tag % 100
        let ten:Int = Int(floor(Float(tensA)/10.0))
        let cents:Int = Int(floor(Float(tag)/100.0))
        
        if(tag % 10 == 1){
            print("いいえ");
            answers[cents*5+ten] = 1
        }else if(tag % 10 == 2){
            print("どちらでもない");
            answers[cents*5+ten] = 2
        }else if(tag % 10 == 3){
            print("はい");
            answers[cents*5+ten] = 3
            
        }

        updateProgress()
        sender.isEnabled = true
        buttonEventAvailabled = true
    }
    func updateProgress(){
        var cnt:Int = 0
        for i in 0...answers.count-1{
            if(answers[i] > 0){
                cnt += 1
            }
        }
        progressBar.progress =  Float(cnt)/40
        progressLabel.text = String(cnt) + "/40"
        
    }
    func loadQuestions() -> NSArray{
//        let path : String = Bundle.main.path(forResource: "resource/questions", ofType: "json")!
//        let jsonData = NSData(contentsOfFile: path)
//        let data = String(NSString(data: jsonData! as Data, encoding: String.Encoding.utf8.rawValue)!)
//        let abe = data.data(using: String.Encoding.utf8)!
//        var questions: NSArray = []
//        do {
//            let json = try JSONSerialization.jsonObject(with: abe, options: JSONSerialization.ReadingOptions.allowFragments)
//            let top = json as! NSArray // トップレベルが配列
//            questions = top
//        } catch {
//            print(error) // パースに失敗したときにエラーを表示
//        }
//        return questions
        return loadJson(fileName:"resource/questions")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! DiagnoseResultViewController
        generateResult()
        viewController.greatManKey = self.greatManKey
        viewController.big5Score = self.big5Score
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (!validateAnswers()) {
            let alert = UIAlertController(title: "エラー", message: "全部に回答していません", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return false;
        }
        
        return true;
    }
    
    func validateAnswers()-> Bool{
        var cnt:Int = 0
        for i in 0...answers.count-1{
            if(answers[i] > 0){
                cnt += 1
            }
        }
        
        return cnt == 40
    }
    
    func generateResult(){
        var openness:Int = 0
        for i in 0...7 {
            openness += answers[i]
        }
        var conscientiousness:Int = 0
        for i in 8...15 {
            conscientiousness += answers[i]
        }
        var extroversion:Int = 0
        for i in 16...23 {
            extroversion += answers[i]
        }
        var agreeableness:Int = 0
        for i in 24...31 {
            agreeableness += answers[i]
        }
        var neuroticism:Int = 0
        for i in 32...39 {
            neuroticism += answers[i]
        }
        
        
        let threshold:NSArray = loadThreshold()
        let threshold0:NSDictionary = threshold[0] as! NSDictionary
        let threshold1:NSDictionary = threshold[1] as! NSDictionary
        let threshold2:NSDictionary = threshold[2] as! NSDictionary
        let threshold3:NSDictionary = threshold[3] as! NSDictionary
        let threshold4:NSDictionary = threshold[4] as! NSDictionary
        
        let thresholdOpenness = threshold0["threshold"] as! Float
        let thresholdConscientiousness = threshold1["threshold"] as! Float
        let thresholdExtroversion = threshold2["threshold"] as! Float
        let thresholdAgreeableness = threshold3["threshold"] as! Float
        let thresholdNeuroticism = threshold4["threshold"] as! Float
        
        big5Score["openness"] = thresholdOpenness
        big5Score["conscientiousness"] = thresholdConscientiousness
        big5Score["extroversion"] = thresholdExtroversion
        big5Score["agreeableness"] = thresholdAgreeableness
        big5Score["neuroticism"] = thresholdNeuroticism
        
        
        let opennessStr =  Float(openness) > thresholdOpenness ? "1":"0"
        let conscientiousnessStr = Float(conscientiousness) > thresholdConscientiousness ? "1":"0"
        let extroversionStr = Float(extroversion) > thresholdExtroversion ? "1":"0"
        let agreeablenessStr = Float(agreeableness) > thresholdAgreeableness ? "1":"0"
        let neuroticismStr = Float(neuroticism) > thresholdNeuroticism ? "1":"0"
        
        self.greatManKey = opennessStr+conscientiousnessStr+extroversionStr+agreeablenessStr+neuroticismStr
    }
    
    func loadThreshold()->NSArray{
        let results: NSArray = loadJson(fileName:"resource/threshold")
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
