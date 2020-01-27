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
    
    var fontSize = Float(17.0){
    didSet{
        movieTableView.reloadData()
        }
    }
    
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
        //Step 4: create an instance of the class of the object that contains the delegate
        guard let settingVC = storyboard?.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController else {
                fatalError("Could not downcast to DetailedViewController")}
        //step5: setting the delegate in your segue since this is how you are passing data
        settingVC.delegate = self
        //this makes your Bar button item segue MODALLY below
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
        //Step6:You need to set the fontsize in the cell for row at
        cell.movieLabel.font = UIFont(name: "Helvetica", size: CGFloat(fontSize))
        cell.movieYearLabel.font = UIFont(name: "Helvetica", size: CGFloat(fontSize))
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
//Step 6: Creating an extension that conforms to the delegate
//this is where i change the font 
extension ViewController: SettingsViewControllerDelegate {
    func fontSizeDidChange(_ settingsViewController: SettingsViewController) {
        fontSize = settingsViewController.fontSize
        
    }
}
