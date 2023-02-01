//
//  ViewController.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 12/30/2022.
//  Copyright (c) 2022 Tuan Dinh. All rights reserved.
//

import UIKit
import linkid_mmp
import SnapKit

class ViewController: UIViewController {
    
    lazy var button = UIButton(type: .system)
    lazy var button2 = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        button.setTitle( "Event1", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(150.0)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        button.addTarget(self, action: #selector(btnClick1(_:)), for: .touchUpInside)
        
        button2.setTitle( "Event2", for: .normal)
        button2.setTitleColor(.white, for: .normal)
        button2.backgroundColor = .blue
        view.addSubview(button2)
        button2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(210.0)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        button2.addTarget(self, action: #selector(btnClick2(_:)), for: .touchUpInside)
        
        LinkIdMMP.intSDK(partnerCode: "partner_code_01", appId: "com.vpbank.linkid_mmp_test")

    }
    
    @objc func btnClick1(_ sender:UIButton!) {
        LinkIdMMP.event(name: "event1", data: nil)
    }
    
    @objc func btnClick2(_ sender:UIButton!) {
        for i in 0...100 {
            LinkIdMMP.event(name: "event2", data: ["key": "value"])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

