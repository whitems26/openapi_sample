//
//  MainTableViewController.swift
//  OpenApi
//
//  Created by ktds 19 on 2017. 8. 31..
//  Copyright © 2017년 cjon. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    @IBAction func onClickMore(_ sender: Any) {
        self.getData(pageNum: self.lastPageNum + 1)
        
        self.tableView.reloadData()
    }
    
    var arts:[Art] = Array()
    let maxQty = 10
    let keyStr = "6f6d45436c776869353276674b5a52"
    var lastPageNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        getData(pageNum:10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell..
        
        cell.textLabel?.text = arts[indexPath.row].title
        cell.detailTextLabel?.text = arts[indexPath.row].artist

//        let imgURL = arts[indexPath.row].thumbImageUrl
//        cell.imageView?.image = getThumbImage(withURL: imgURL!)
        
        if let thumbImage = arts[indexPath.row].thumbImage {
            cell.imageView?.image = thumbImage
        }
        else{
            if let thumbImageURL = arts[indexPath.row].thumbImageUrl {
                DispatchQueue.global(qos: .userInitiated).async(execute: {
                    self.arts[indexPath.row].thumbImage = self.getThumbImage(withURL: thumbImageURL)
               
                    guard let thumbImage = self.arts[indexPath.row].thumbImage else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        cell.imageView?.image = thumbImage
                    }

                    
                })
            
            }
        }
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getData(pageNum:Int) {
        let startIdx = pageNum * maxQty
        let endIdx = startIdx + maxQty - 1
        
        let urlStr = "http://openapi.seoul.go.kr:8088/\(keyStr)/json/SemaPsgudInfo/\(startIdx)/\(endIdx)/"
    
        let serverURL : URL! = URL(string: urlStr)
        
        let serverData = try! Data(contentsOf: serverURL)
        
        let log = NSString(data: serverData, encoding: String.Encoding.utf8.rawValue)
        
        print(log)
        
        do{
            let dict = try JSONSerialization.jsonObject(with: serverData, options: []) as! NSDictionary
            
            let semaPsgudInfo = dict["SemaPsgudInfo"] as! NSDictionary
            
            let results = semaPsgudInfo["row"] as! NSArray
            
            for result in results {
                let resultDict = result as! NSDictionary
                
                let art = Art(title: resultDict["PRDCT_NM_KOREAN"] as? String,
                             artist: resultDict["WRITR_NM"] as? String,
                             thumbImageUrl: resultDict["THUMB_IMAGE"] as? String)
                
                
                arts.append(art)
            }
            
        }catch{
            print("Error")
        }
        
        self.lastPageNum = pageNum
    }

    func getThumbImage(withURL imageURL:String) -> UIImage? {
        let url:URL! = URL(string: imageURL)
        let imgData = try! Data(contentsOf: url)
        let image = UIImage(data: imgData)
        
        return image
    }
}
