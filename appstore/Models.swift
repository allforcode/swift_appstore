//
//  Models.swift
//  appstore
//
//  Created by Paul Dong on 8/10/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit

class FeaturedApps: NSObject {
    var bannerCategory: AppCategory?
    var categories: [AppCategory]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "categories" {
            categories = [AppCategory]()

            for dict in value as! [[String: AnyObject]]  {
                let appCategory = AppCategory()
                appCategory.setValuesForKeys(dict)
                categories?.append(appCategory)
            }
        } else if key == "bannerCategory" {
            bannerCategory = AppCategory()
            bannerCategory?.setValuesForKeys(value as! [String: AnyObject])
        } else {
            super.setValue(value, forKey: key)
        }
    }
}

class AppCategory: NSObject {
    var name: String?
    var apps: [App]?
    var type: String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "apps" {
            
            apps = [App]()
            for dict in value as! [[String: AnyObject]] {
                let app = App()
                app.setValuesForKeys(dict)
                apps?.append(app)
            }
            
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    static func fetchFeaturedApps(_ completion: @escaping (FeaturedApps) -> ()){
        let urlString = "https://api.letsbuildthatapp.com/appstore/featured"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let err = error {
                    print("******** error ********")
                    print(err)
                    return
                }

                do {
                    if let unwrappedData = data {
                        let json = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as! [String: AnyObject]
                        
                        let featruedApp = FeaturedApps()
                        featruedApp.setValuesForKeys(json)

                        DispatchQueue.main.async {
                            completion(featruedApp)
                        }

                    }

                } catch let err {
                    print(err)
                }
            }.resume()
        }
    }
    
//    static func sampleAppCategories() -> [AppCategory] {
//        var appCategories = [AppCategory]()
//
//        //first category
//        let bestNewAppsCategory = AppCategory()
//        bestNewAppsCategory.name = "Best New Apps"
//
//        var apps = [App]()
//
//        let frozenApp = App()
//        frozenApp.name = "Disney Build It: Frozen"
//        frozenApp.imageName = "frozen"
//        frozenApp.category = "Entertainment"
//        frozenApp.price = NSNumber(value: 3.99)
//        apps.append(frozenApp)
//        bestNewAppsCategory.apps = apps
//        appCategories.append(bestNewAppsCategory)
//
//        //second category
//        let bestNewGamesCategory = AppCategory()
//        bestNewGamesCategory.name = "Best New Games"
//
//        apps.removeAll()
//
//        let telepaintApp = App()
//        telepaintApp.name = "Telepaint"
//        telepaintApp.imageName = "telepaint"
//        telepaintApp.category = "Games"
//        telepaintApp.price = NSNumber(value: 2.99)
//        apps.append(telepaintApp)
//
//        bestNewGamesCategory.apps = apps
//        appCategories.append(bestNewGamesCategory)
//
//        return appCategories
//    }
}

class App: NSObject {
    var id: NSNumber?
    var name: String?
    var category: String?
    var imageName: String?
    var price: NSNumber?
    
    var screenshots: [String]?
    var desc: String?
    var appInformation: [[String: String]]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "description" {
            if let v = value as? String {
                self.desc = v
            }
        }else{
            super.setValue(value, forKey: key)
        }
    }
    
}
