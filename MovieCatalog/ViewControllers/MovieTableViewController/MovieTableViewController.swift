//
//  MovieTableViewController.swift
//  MovieCatalog
//
//  Created by Aleksei Penzentcev on 19/11/2017.
//  Copyright © 2017 lexpenz.com. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class MovieTableViewController: UIViewController, ConnectionErrorPresentable {
    private struct Consts {
        static let searchBarHeight: CGFloat = 50
    }
    
    lazy var searchBar: UISearchBar = UISearchBar()
    
    let tableView = UITableView()
    
    fileprivate let realm = Realm.defaultRealm()
    fileprivate var movieList: Results<Movie>?
    
    fileprivate let tableManager = MovieTableViewManager()
    
    fileprivate var keyboardPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        tableManager.tableView = tableView
        tableManager.openMovieDetailsHandler = { [unowned self] movie in
            if self.keyboardPresented {
                self.searchBar.resignFirstResponder()
            } else {
                let vc = MovieDetailsViewController()
                vc.movie = movie
                AppDelegate.shared.pushViewController(viewController: vc, animated: true)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: Notification.Name.reachabilityChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillAppear() {
        keyboardPresented = true
    }
    
    @objc func keyboardWillDisappear() {
        keyboardPresented = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reachabilityChanged(note: Notification) {
        if !ReachabilityManager.shared.isConnected {
            showConnectionErrorAlert()
        }
    }
    
    private func setupUI() {
        title = NSLocalizedString("Movies", comment: "")
        
        view.addSubview(tableView)
        view.addSubview(searchBar)
        
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = NSLocalizedString("search...", comment: "")
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.top.equalTo(self.view)
            make.bottom.equalTo(searchBar.snp.top)
        }
        searchBar.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.height.equalTo(Consts.searchBarHeight)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: nil)
    }
}

//MARK: - UISearchBar Delegate
extension MovieTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        tableManager.filterMovie(text: textSearched)
    }
}
