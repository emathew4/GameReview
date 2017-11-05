//
//  GameTableViewController.swift
//  GameReviewer
//
//  Created by Ethan Mathew on 11/4/17.
//  Copyright © 2017 Ethan Mathew. All rights reserved.
//

import UIKit
import os.log

class GameTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var games = [Game]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        loadSampleMeals()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return games.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GameTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GameTableViewCell else {
            fatalError("The dequeued cell is not an instance of GameTableViewCell.")
        }

        // Configure the cell...
        let game = games[indexPath.row]
        cell.nameLabel.text = game.name
        cell.photoImageView.image = game.photo
        cell.ratingControl.rating = game.rating

        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            games.remove(at: indexPath.row)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let gameDetailViewController = segue.destination as? GameViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedGameCell = sender as? GameTableViewCell else {
                fatalError("Unexpected sender \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedGameCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedGame = games[indexPath.row]
            gameDetailViewController.game = selectedGame
            
        default:
            fatalError("Unexpected Segue Identifier: \(segue.identifier)")
        }
    }
    
    //MARK: Actions
    
    @IBAction func unwindToGameList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? GameViewController, let game = sourceViewController.game {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                games[selectedIndexPath.row] = game
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                let newIndexPath = IndexPath(row: games.count, section: 0)
                games.append(game)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    //MARK: Private Methods
    
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "clashOfClans")
        let photo2 = UIImage(named: "summonersWar")
        let photo3 = UIImage(named: "mobileLegends")
        
        guard let game1 = Game(name: "Clash of Clans", photo: photo1, rating: 4)
            else {
                fatalError("Unable to instantiate game1")
        }
        
        guard let game2 = Game(name: "Summoners War", photo: photo2, rating: 5)
            else {
                fatalError("Unable to instantiate game2")
        }
        
        guard let game3 = Game(name: "Mobile Legends", photo: photo3, rating: 3)
            else {
                fatalError("Unable to instantiate game3")
        }
        
        games += [game1, game2, game3]
    }

}