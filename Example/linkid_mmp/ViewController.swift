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
        let   options = AirflexOptions()
        options.showLog = true
//        LinkIdMMP.intSDK(partnerCode: "lynk_id_uat", appSecret: "b3ccd1c20fa9154a559c304956f99b302027a87b87ad520c1c4dbdd4bb54be7a")
                Airflex.intSDK(partnerCode: "myvpbank_uat", appSecret: "7fe95468c204397de9bcda2d702d4501a174976b1d003d92d1e5550b03f9fcb5", options: options)
        Airflex.handleDeeplink { url in
            print(url)
        }
    }
    
    @objc func btnClick1(_ sender:UIButton!) {
        Airflex.logEvent(name: "event1", data: nil)
//        let exception = NSException(name: NSExceptionName(rawValue: "arbitrary ffdfdf"), reason: "arbitrary reason", userInfo: nil)
//        exception.raise()
    }
    
    @objc func btnClick2(_ sender:UIButton!) {
//        LinkIdMMP.setUserInfo(userInfo: UserInfo.create(userId: "tuandv8", name: "", gender: "", email: "", phone: "", age: 0, country: "", city: "", deviceToken: ""))
//        var user: UserInfo?
//        print("\(user!.toDictionary())")
//        let exception = NSException(name: NSExceptionName(rawValue: "arbitrary"), reason: "arbitrary reason", userInfo: nil)
//        exception.raise()
//        Airflex.logEvent(name: "event2", data: ["tuandv8": "IT-DF"])
        
        let linkBuilder = DeepLinkBuilder()
        
        let iOSParameters = DeepLinkIOSParameters(bundleID: "com.vpbank.myvpbank")
        iOSParameters.appStoreID = "112233"
        linkBuilder.iOSParameters = iOSParameters
        
        let androidParameters = DeepLinkAndroidParameters(packageName: "com.vpbank.myvpbank")
        linkBuilder.androidParameters = androidParameters
        
        let airflexParameters = DeepLinkAirflexParameters(source: "app", code: "11223344", medium: "medium", campaign: "campaign1")
        linkBuilder.airflexParameters = airflexParameters
        
        linkBuilder.createLink { result, error in
            print("-------TUANDV8-------")
            if let result = result {
                print(result.longLink)
                print(result.shortLink)
            } else if let error = error {
                print(error.message)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

