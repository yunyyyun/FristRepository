//
//  ViewController.swift
//  test extension
//
//  Created by mengyun on 2016/10/23.
//  Copyright © 2016年 mengyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func clk(_ sender: AnyObject) {
        let str=text.text
        lab.text=str
        let md=Mdata()
        md.contentStr=str!
        Mdata.encode(md)
    }
    @IBOutlet var btn: UIButton!
    @IBOutlet var text: UITextField!
    @IBOutlet var lab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let md = Mdata.decode(3)
        lab.text=md?.contentStr
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
