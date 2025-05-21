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
    lazy var button3 = UIButton(type: .system)
    lazy var button4 = UIButton(type: .system)
    var adView: AirflexAdView!
    var adView2: AirflexAdView!

    override func viewDidLoad() {
        super.viewDidLoad()
        adView = AirflexAdView(context: view, adType: .PRODUCT, adId: "00dd59d2-5fae-4b8a-999b-f65da21c438a")
        adView2 = AirflexAdView(context: view, adType: .BANNER, adId: "93cc89ad-f1d9-4674-a8e1-6df6f55805a7")
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
        
        
        button3.setTitle( "Game1", for: .normal)
        button3.setTitleColor(.white, for: .normal)
        button3.backgroundColor = .blue
        view.addSubview(button3)
        button3.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(270.0)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        button3.addTarget(self, action: #selector(btnClick3(_:)), for: .touchUpInside)
        
        
        button4.setTitle( "Game2", for: .normal)
        button4.setTitleColor(.white, for: .normal)
        button4.backgroundColor = .blue
        view.addSubview(button4)
        button4.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(330.0)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        button4.addTarget(self, action: #selector(btnClick4(_:)), for: .touchUpInside)
        
        view.addSubview(adView)
        adView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(400.0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(50)
        }
        adView.showAd()
        view.addSubview(adView2)
        adView2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(600.0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(50)
        }
        adView2.showAd()

    }
    
    @objc func btnClick1(_ sender:UIButton!) {
//        Airflex.logEvent(name: "event1", data: ["afRealtime": true])
        Airflex.setFlag(flagKey: "tuan_test", flagValue: "1") { flagData in
            print(flagData.toString())
        }
//        let exception = NSException(name: NSExceptionName(rawValue: "arbitrary ffdfdf"), reason: "arbitrary reason", userInfo: nil)
//        exception.raise()
    }
    
    @objc func btnClick3(_ sender:UIButton!) {
//        Airflex.getFlags(flagKey: "tuan_test2", limit: 100, offset: 0) { flagData in
//            print(flagData.toString())
//        }
//        AirflexDeepLinkDelegate.shared.handleUniversalLink(incomingURL: "https://s-uat.linkid.vn/sPWbJ8h") { redirectUrl, longLink, error in
//            print("redirectUrl \(redirectUrl ?? "") longLink \(longLink ?? "")")
//        }
//        Airflex.clear()
//        Airflex.intSDK(partnerCode: "myvpbank_uat", appSecret: "7fe95468c204397de9bcda2d702d4501a174976b1d003d92d1e5550b03f9fcb5", extra: "game1")
        AirflexAdHelper.getAd(adId: "93cc89ad-f1d9-4674-a8e1-6df6f55805a7", adType: "BANNER") { adItem in
            if let adItem = adItem {
                print("onSuccess: \(adItem.toJsonString() ?? "")")
            } else {
                print("onFailure: Failed to get ad")
            }
        }
    }
    
    @objc func btnClick4(_ sender:UIButton!) {
        Airflex.clear()
        Airflex.initSDK(partnerCode: "myvpbank_uat", appSecret: "7fe95468c204397de9bcda2d702d4501a174976b1d003d92d1e5550b03f9fcb5", extra: "game2")
    }
    
    @objc func btnClick2(_ sender:UIButton!) {
        Airflex.setUserInfo(userInfo: UserInfo.create(userId: "tuandv8", name: "", gender: "", email: "", phone: "", age: 0, country: "", city: "", deviceToken: ""))
//        var user: UserInfo?
//        print("\(user!.toDictionary())")
//        let exception = NSException(name: NSExceptionName(rawValue: "arbitrary"), reason: "arbitrary reason", userInfo: nil)
//        exception.raise()
//        Airflex.logEvent(name: "event2", data: ["tuandv8": "IT-DF"])
        
        
        //        var products : [ProductItem] = []
        //
        //        var item1: ProductItem = ProductItem(id: "productId01", name: "productName01", image: "productImage01", price: "100")
        //        item1.addCategory(category: ProductCategory(categoryId: "catId01", categoryName: "catName01"))
        //        item1.addCategory(category: ProductCategory(categoryId: "catId02", categoryName: "catName02"))
        //
        //        var item2: ProductItem = ProductItem(id: "productId02", name: "productName02", image: "productImage02", price: "100")
        //        item2.addCategory(category: ProductCategory(categoryId: "catId01", categoryName: "catName01"))
        //        item2.addCategory(category: ProductCategory(categoryId: "catId03", categoryName: "catName03"))
        //
        //        products.append(item1)
        //        products.append(item2)
        //
        //        Airflex.setProductList(listName: "tuan_test", products: products)
        
        let linkBuilder = DeepLinkBuilder()
        
        let iOSParameters = DeepLinkIOSParameters(bundleID: "com.vpbank.myvpbank")
        iOSParameters.appStoreID = "112233"
        linkBuilder.iOSParameters = iOSParameters
        
        let androidParameters = DeepLinkAndroidParameters(packageName: "com.vpbank.myvpbank")
        linkBuilder.androidParameters = androidParameters
        
        let airflexParameters = DeepLinkAirflexParameters(name: "Test From SDK iOS", source: "app", code: "11223344", medium: "medium", campaign: "campaign1")
        airflexParameters.shortLinkId = "123456789"
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
        
        linkBuilder.createShortLink(longLink: "https://google.com") { result, error in
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

