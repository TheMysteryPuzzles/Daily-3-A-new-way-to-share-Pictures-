//
//  SearchViewController.swift
//  Storify
//
//  Created by Work on 5/29/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit
import Firebase


class SearchViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
  
    let searchController = UISearchController(searchResultsController: nil)
    
    let peopleRef = Database.database().reference(withPath: "people")
    var people = [Daily3User]()
    
    let emptyLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = "No people found."
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 20)
        messageLabel.sizeToFit()
        return messageLabel
    }()
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up tableview
          tableView.register(SearchCellView.self, forCellReuseIdentifier: cellid)
        
        // Setting up search controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Here"
        
       
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).leftViewMode = .never
        
        //searchController.searchBar.setImage(#imageLiteral(resourceName: "ic_edit"), for: .clear, state: .normal)
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        searchController.searchBar.showsCancelButton = false
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.init(red: 0, green: 137/255, blue: 249/255, alpha: 1)
    }
   
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = false
        self.searchController.searchBar.becomeFirstResponder()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false
         self.searchController.searchBar.becomeFirstResponder()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global(qos: .default).async(execute: {
            DispatchQueue.main.async(execute: {
                self.searchController.searchBar.becomeFirstResponder()
            })
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All"){
        
        
        print("Filtering")
        if searchText.isEmpty{
            return
        }
        let searchString = searchText.lowercased()
        
        // MARK-> Cancels the currently pending item
        pendingRequestWorkItem?.cancel()
        
        // Wrapping A request in a work item
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.people = [Daily3User]()
            self?.tableView.reloadData()
            self?.tableView.performBatchUpdates({
                self?.search(searchString, at: "full_name")
                self?.search(searchString, at: "reversed_full_name")
            }, completion: nil)
        
        }
        // Save the new work item and execute it after 250 ms
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                      execute: requestWorkItem)
    }
    
    private func search(_ searchString: String, at index: String) {
        print("calling search")
        print("Searched: "+searchString)
        peopleRef.queryOrdered(byChild: "_search_index/\(index)").queryStarting(atValue: searchString).queryLimited(toFirst: 10).observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            if snapshot.exists(){ print("got snapshot")}
            while let person = enumerator.nextObject() as? DataSnapshot {
                if let value = person.value as? [String:Any], let searchIndex =
                    value["_search_index"] as? [String:Any],let fullName = searchIndex[index] as? String, fullName.hasPrefix(searchString){
                    // MAKING NEW USER
                    self.people.append(Daily3User(snapshot: person))
                    self.tableView.insertRows(at: [IndexPath(item: self.people.count - 1, section: 0)], with: .automatic)
                    
                }
            }
        }
    }
    
    


    
    
    // MARK-> TABLE VIEW IMPLEMENTATION
    
     var cellid = "cellidd"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! SearchCellView
        let user = people[indexPath.row]
        cell.textLabel?.text = user.name
        // cell.detailTextLabel?.text = user.email
        if let profileImageUrl = user.profileImageDownloadUrl{
            cell.profileImageView.loadImageUsingCache(withUrl: profileImageUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("selected")
        
        let profile = people[indexPath.item]
        let accountVC = UserAccountViewController()
        accountVC.profile = profile
        self.navigationController?.pushViewController(accountVC, animated: true)
    }
    
    
    


}

extension SearchViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

