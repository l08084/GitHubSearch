//
//  SearchViewController.swift
//  GItHubSearch
//
//  Created by l08084 on 2016/08/18.
//  Copyright © 2016年 l08084. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, ApplicationContextSettable {
    
    var appContext: ApplicationContext!
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.delegate = self
        controller.searchBar.delegate = self
        return controller
    }()
    
    var searchManager: SearchRepositoriesManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.destinationViewController {
        case let repositoryVC as RepositoryViewController:
            repositoryVC.appContext = appContext
            if let indexPath = tableView.indexPathForSelectedRow,
                let repository = searchManager?.results[indexPath.row] {
                repositoryVC.repository = repository
            }
        default:
            fatalError("Unexpected segue")
        }
    }
    
    // MARK: - Table,view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchManager?.results.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RepositoryCell", forIndexPath: indexPath)
        
        let repository = searchManager!.results[indexPath.row]
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = repository.description
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let searchManager = searchManager where indexPath.row >= searchManager.results.count - 1 {
            searchManager.search(false) { [weak self] (error) in
                if let error = error {
                    print(error)
                } else {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
}

extension SearchViewController: UISearchControllerDelegate {
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        guard let searchManager = SearchRepositoriesManager(github: appContext.github, query: searchText) else { return }
        self.searchManager = searchManager
        searchManager.search(true) { [weak self] (error) in
            if let error = error {
                print(error)
            } else {
                self?.tableView.reloadData()
                self?.searchController.active = false
            }
        }
    }
}