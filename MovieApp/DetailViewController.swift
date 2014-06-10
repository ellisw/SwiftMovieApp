//
//  DetailViewController.swift
//  MovieApp
//
//  Created by Ellis Weng on 6/6/14.
//  Copyright (c) 2014 Ellis Weng. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UISplitViewControllerDelegate {

    var masterPopoverController: UIPopoverController? = nil

    @IBOutlet var backgroundImage : UIImageView
    @IBOutlet var scrollView : UIScrollView
    @IBOutlet var descriptionTextView : UITextView

    var detailItem: AnyObject? {
        didSet {
            self.configureView()

            if self.masterPopoverController != nil {
                self.masterPopoverController!.dismissPopoverAnimated(true)
            }
        }
    }

    func configureView() {
        if let movie: Movie = self.detailItem as? Movie {
            self.title = movie.title
            if let image = self.backgroundImage {
                image.setImageWithURL(movie.posterDetailedUrl)
            }
            if let scrollView = self.scrollView {
                // Any advice on how to do this through IB?
                var textView = UITextView()
                textView.text = movie.movieDescription
                textView.textColor = UIColor.whiteColor()
                textView.selectable = true
                textView.editable = true
                textView.font = UIFont(name: "Helvetica", size: 20)
                var background = UIColor.blackColor()
                background = background.colorWithAlphaComponent(0.8)
                textView.backgroundColor = background
                textView.selectable = false
                textView.editable = false
                scrollView.addSubview(textView)
                var newSize = textView.sizeThatFits(CGSizeMake(320, CGFLOAT_MAX))
                var newFrame = textView.frame
                newFrame.size = CGSizeMake(320.0, newSize.height);
                newFrame.origin = CGPoint(x: 0, y: 150)
                textView.frame = newFrame;
                scrollView.contentSize = CGSizeMake(320, newSize.height + 150)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    // #pragma mark - Split view

    func splitViewController(splitController: UISplitViewController, willHideViewController viewController: UIViewController, withBarButtonItem barButtonItem: UIBarButtonItem, forPopoverController popoverController: UIPopoverController) {
        barButtonItem.title = "Movies"
        self.navigationItem.setLeftBarButtonItem(barButtonItem, animated: true)
        self.masterPopoverController = popoverController
    }

    func splitViewController(splitController: UISplitViewController, willShowViewController viewController: UIViewController, invalidatingBarButtonItem barButtonItem: UIBarButtonItem) {
        // Called when the view is shown again in the split view, invalidating the button and popover controller.
        self.navigationItem.setLeftBarButtonItem(nil, animated: true)
        self.masterPopoverController = nil
    }
    func splitViewController(splitController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }

}

