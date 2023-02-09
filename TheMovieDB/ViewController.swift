//
//  ViewController.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import UIKit
import Cleanse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (UIApplication.shared.delegate as? ProvideInjectorResolver)?.injectorResolver.inject(self)
        goToMainPage()
    }

    var data: GetMovieReviewListDataSource?
    func injectProperties(
            viewController: TaggedProvider<MyBaseUrl>,
            data: GetMovieReviewListDataSource
    ){
        self.data = data
    }
    
    func goToMainPage() {
        guard let vc = (UIApplication.shared.delegate as? ProvideViewControllerResolver)?.vcResolver.instantiateHomeViewController().get() else {
            fatalError("View Controller can't be nil: Genre")
        }
        let navController = UINavigationController(rootViewController: vc)
        vc.navigationItem.title = "Genre"
        self.presentInFullScreen(navController, animated: true)
    }
}

