//
//  ViewController.swift
//  MVC+Delegation-Review-Lab
//
//  Created by Benjamin Stone on 8/19/19.
//  Copyright © 2019 Benjamin Stone. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    
    
    var userQuery = "" {
        didSet {
            allMovies = Movie.allMovies.filter{$0.name.lowercased().contains(userQuery.lowercased())}
        }

    }
    var allMovies = Movie.allMovies {
        didSet {
            movieTableView.reloadData()
        }
    }
    // the tableview is able to reload the data when they stop using the search bar
    var isSearchBarEmpty: Bool {
        return movieSearchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        movieSearchBar.delegate = self
        movieTableView.delegate = self
    }


    @IBAction func settingsBarButton(_ sender: UIBarButtonItem) {
       //Melinda Don't forget that this is segueing!!!!!!!
            guard let settingVC = storyboard?.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController else {
                fatalError("Could not downcast to DetailedViewController")}
        //this makes your Barbutton item segue MODULLY below
        navigationController?.pushViewController(settingVC, animated: true)
        }
       
    }


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = movieTableView.dequeueReusableCell(withIdentifier: "tableCell") as? TableViewCell else { fatalError("Could not downcast to TableViewCell")}
        cell.movieLabel.text = allMovies[indexPath.row].name
        cell.movieYearLabel.text = allMovies[indexPath.row].year.description
        return cell
        }
        
    }
    
    

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            allMovies = Movie.allMovies
               return
        }
    userQuery = searchText
    }
    //in order for the searchBar to work you need to use a didSet on BOTH userQuery AND allMovie variables or else it does not work completely
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
        
    }
}

