//
//  GameFavoritesTableViewController.swift
//  GameReviewer
//
//  Created by Ethan Mathew on 11/5/17.
//  Copyright © 2017 Ethan Mathew. All rights reserved.
//

import UIKit
import os.log

class GameFavoritesTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var favorites = [Game]()

    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("Super loaded.", log: OSLog.default, type: .debug)


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let savedFavorites = loadFavorites() {
            favorites += savedFavorites
        } else {
            os_log("Going to load favorites.", log: OSLog.default, type: .debug)

            loadSampleMeals()
            os_log("Favorites loaded.", log: OSLog.default, type: .debug)

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

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    
    private func saveFavorites() {
        sortFavorites()
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(favorites, toFile: Game.ArchiveURL2.path)
        
        if isSuccessfulSave {
            os_log("Favorites succesfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save favorites...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadFavorites() -> [Game]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Game.ArchiveURL2.path) as? [Game]
    }
    
    private func sortFavorites() {
        favorites = favorites.sorted{ $0.name < $1.name}
    }
    
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "clashOfClans")
        let photo2 = UIImage(named: "summonersWar")
        let photo3 = UIImage(named: "mobileLegends")
        
        let summary1 = "Join millions of players worldwide as you build your village, raise a clan, and compete in epic Clan Wars!"
        let summary2 = "Assemble the greatest team of monsters for strategic victories!"
        let summary3 = "Join your friends in a brand new 5v5 MOBA showdown against real human opponents, Mobile Legends: Bang Bang!"
        
        
        guard let game1 = Game(name: "Clash of Clans", photo: photo1, rating: 4, summary: summary1)
            else {
                fatalError("Unable to instantiate game1")
        }
        
        guard let game2 = Game(name: "Summoners War", photo: photo2, rating: 5, summary: summary2)
            else {
                fatalError("Unable to instantiate game2")
        }
        
        guard let game3 = Game(name: "Mobile Legends", photo: photo3, rating: 3, summary: summary3)
            else {
                fatalError("Unable to instantiate game3")
        }
        
        favorites += [game1, game2, game3]
    }
    
}
