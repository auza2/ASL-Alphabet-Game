//
//  ViewController.swift
//  ASL Alphabet Game
//
//  Created by Jamie Auza on 1/31/18.
//  Copyright © 2018 Jamie Auza. All rights reserved.
//

import UIKit
class customCell: UITableViewCell{
    @IBOutlet weak var signImage: UIImageView!
    @IBOutlet weak var label: UILabel!
}

class TableViewController: UITableViewController {
    
    var imageNames = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items =  try! fm.contentsOfDirectory(atPath: path)
        
        for filename in items{
            if(filename.hasSuffix(".png")){
                imageNames.append(filename)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! customCell
        
        let filename = imageNames[indexPath.row]
        cell.label.text = filename.replacingOccurrences(of: ".png", with: "")
        cell.signImage.image = UIImage(named: filename)
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageNames.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

