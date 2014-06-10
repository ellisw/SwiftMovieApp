//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Ellis Weng on 6/6/14.
//  Copyright (c) 2014 Ellis Weng. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        let tabViewController = self.window!.rootViewController as UITabBarController
        let boxOffice = ["url" : "movies/box_office", "title" : "Box Office", "image" : "box_office.png"]
        let topDvds = ["url" : "dvds/top_rentals", "title" : "Top DVDs", "image" : "top_dvds.png"]
        let tabData = [boxOffice, topDvds]
        for (var i = 0; i < 2; i++) {
            var data = tabData[i]
            var urlPart = data["url"]
            var splitViewController = tabViewController.viewControllers[i] as UISplitViewController
            splitViewController.tabBarItem = UITabBarItem(title: data["title"], image: UIImage(named:data["image"]), tag: i)

            var masterNavigationController = splitViewController.viewControllers[0] as UINavigationController
            var masterController = masterNavigationController.topViewController as MasterViewController
            masterController.url = "http://api.rottentomatoes.com/api/public/v1.0/lists/\(urlPart).json?apikey=g9au4hv6khv6wzvzgt55gpqs"

            var detailNavigationController = splitViewController.viewControllers[1] as UINavigationController
            splitViewController.delegate = detailNavigationController.topViewController as DetailViewController
        }
        return true
    }
}

