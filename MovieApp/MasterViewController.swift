//
//  MasterViewController.swift
//  MovieApp
//
//  Created by Ellis Weng on 6/6/14.
//  Copyright (c) 2014 Ellis Weng. All rights reserved.
//

import UIKit
import Foundation

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = NSMutableArray()
    var url : NSString? = nil
    var networkErrorLabel : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.beginRefreshing()
        refresh()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.endIndex-1].topViewController as? DetailViewController
        }
    }

    func refresh() {
        if let url = self.url {
            var request = NSURLRequest(URL: NSURL.URLWithString(url))
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()){
                (response, data, connectionError) in
                if let error = connectionError {
                    if (!self.networkErrorLabel) {
                        var networkErrorLabel = UILabel()
                        networkErrorLabel.text = "Network Error"
                        networkErrorLabel.textColor = UIColor.whiteColor()
                        networkErrorLabel.font = UIFont(name: "Helvetica-Bold", size: 12)
                        networkErrorLabel.backgroundColor = UIColor.darkGrayColor()
                        networkErrorLabel.frame = CGRectMake(0 , 0, 320, 25)
                        networkErrorLabel.textAlignment = NSTextAlignment.Center
                        self.networkErrorLabel = networkErrorLabel
                    }
                    self.view.addSubview(self.networkErrorLabel)
                } else {
                    self.networkErrorLabel?.removeFromSuperview()
                    // Have to cast to AnyObject because of bug with dictionaries in swift
                    let obj : AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)
                    let dict : NSDictionary = obj as NSDictionary
                    if let movies : NSArray = dict["movies"] as? NSArray{
                        for (movie : AnyObject) in movies {
                            self.objects.addObject(Movie(movie as NSDictionary))
                        }
                    }
                    self.tableView.reloadData()
                }
                self.refreshControl.endRefreshing()
            }
        }
    }

    // #pragma mark - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let object = objects[indexPath.row] as Movie
            ((segue.destinationViewController as UINavigationController).topViewController as DetailViewController).detailItem = object
        }
    }

    // #pragma mark - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as MasterTableViewCell
        let object = objects[indexPath.row] as Movie
        cell.title.text = object.title
        cell.movieDescription.text = object.movieDescription
        cell.movieDescription.userInteractionEnabled = false
        cell.posterImage.setImageWithURL(object.posterUrl)
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            let object = objects[indexPath.row] as Movie
            self.detailViewController!.detailItem = object
        }
    }
}

