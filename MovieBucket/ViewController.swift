//
//  ViewController.swift
//  MovieBucket
//
//  Created by Niklas Persson on 2018-03-20.
//  Copyright © 2018 Niklas Persson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let headerView = UIView()
        headerView.backgroundColor = .red
        self.view.addSubview(headerView)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

