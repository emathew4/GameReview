//
//  GameFavoritesTableViewController.swift
//  GameReviewer
//
//  Created by Ethan Mathew on 11/5/17.
//  Copyright © 2017 Ethan Mathew. All rights reserved.
//

import UIKit

class GameFavoritesTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var favorites = [Game]()
    var games = [Game]()

    override func viewDidLoad() {
        super.viewDidLoad()

        addBackButton()
        navigationItem.rightBarButtonItem = editButtonItem

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let savedGames = loadGames() {
            games += savedGames
        } else {
            games = [Game]()
        }
        
        if let savedFavorites = loadFavorites() {
            favorites += savedFavorites
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FavoritesTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GameFavoritesTableViewCell else {
            fatalError("The dequeued cell is not an instance of FavoritesTableViewCell.")
        }
        // Configure the cell...
        let favorite = favorites[indexPath.row]
        cell.nameLabel.text = favorite.name
        cell.photoImageView.image = favorite.photo
        cell.ratingControl.rating = favorite.rating

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let game = favorites[indexPath.row]
            let name = game.name
            
            for ind in 0..<games.count {
                if games[ind].name == name {
                    games[ind].favorite = false
                    break
                }
            }
            
            favorites.remove(at: indexPath.row)
            
            saveGames()
            saveFavorites()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: Private Methods
    
    private func saveGames() {
        sortGames()
        let _ = NSKeyedArchiver.archiveRootObject(games, toFile: Game.ArchiveURL.path)
    }
    
    private func loadGames() -> [Game]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Game.ArchiveURL.path) as? [Game]
    }
    
    private func sortGames() {
        games = games.sorted{ $0.name < $1.name}
    }
    
    private func saveFavorites() {
        sortFavorites()
        let _ = NSKeyedArchiver.archiveRootObject(favorites, toFile: Game.ArchiveURL2.path)
    }
    
    private func loadFavorites() -> [Game]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Game.ArchiveURL2.path) as? [Game]
    }
    
    private func sortFavorites() {
        favorites = favorites.sorted{ $0.name < $1.name}
    }
    
    func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "BackButton.png"), for: .normal)
        backButton.setTitle(" Back", for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func backAction(_ sender: UIButton) {
        saveGames()
        saveFavorites()

        dismiss(animated: true, completion: nil)
    }
    
}
