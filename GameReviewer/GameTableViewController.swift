//
//  GameTableViewController.swift
//  GameReviewer
//
//  Created by Ethan Mathew on 11/4/17.
//  Copyright © 2017 Ethan Mathew. All rights reserved.
//

import UIKit

extension GameTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class GameTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var games = [Game]()
    let searchController = UISearchController(searchResultsController: nil)

    
    var filteredGames = [Game]()
    var favoriteGames = [Game]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackButton()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Games"

        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            if let savedGames = loadGames() {
                games += savedGames
            }
        } else {
            loadSampleGames()
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
       /* if let savedGames = loadGames() {
            games += savedGames
        }
        else {
            loadSampleGames()
        } */
    
        if let savedFavorites = loadFavorites() {
            favoriteGames += savedFavorites
        }

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
        if isFiltering() {
            return filteredGames.count
        }
        return games.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GameTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GameTableViewCell else {
            fatalError("The dequeued cell is not an instance of GameTableViewCell.")
        }

        // Configure the cell...
        let game: Game
        if isFiltering() {
            game = filteredGames[indexPath.row]
        }
        else {
            game = games[indexPath.row]
        }
        cell.nameLabel.text = game.name
        cell.photoImageView.image = game.photo
        cell.ratingControl.rating = game.rating
        
        if game.favorite {
            cell.contentView.backgroundColor = UIColor.init(red: 252/255, green: 194/255, blue: 0, alpha: 1)
        } else {
            cell.contentView.backgroundColor = UIColor.white
        }

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
            let game = games[indexPath.row]
            
            for ind in 0..<favoriteGames.count {
                if favoriteGames[ind].name == game.name {
                    favoriteGames.remove(at: ind)
                    break
                }
            }
            
            games.remove(at: indexPath.row)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
                break
            
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

                if game.favorite && !isFavoriteAlready(game) {
                    favoriteGames.append(game)
                } else if !game.favorite && isFavoriteAlready(game) {
                    for ind in 0..<favoriteGames.count {
                        if favoriteGames[ind].name == game.name {
                            favoriteGames.remove(at: ind)
                            break
                        }
                    }
                }
                
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                let newIndexPath = IndexPath(row: games.count, section: 0)
                games.append(game)
                
                if game.favorite {
                    favoriteGames.append(game)
                }
                
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveGames()
            saveFavorites()
        }
        tableView.reloadData()
    }
    
    //MARK: Private Methods
    
    private func loadSampleGames() {
        let photo1 = UIImage(named: "clashOfClans")
        let photo2 = UIImage(named: "summonersWar")
        let photo3 = UIImage(named: "mobileLegends")
        let photo4 = UIImage(named: "assassinsCreedOrigins")
        let photo5 = UIImage(named: "divinityOriginalSin2")
        let photo6 = UIImage(named: "undertale")
        let photo7 = UIImage(named: "wolfenstein2")
        let photo8 = UIImage(named: "southParkFractured")
        let photo9 = UIImage(named: "kensho")
        let photo10 = UIImage(named: "superMarioRun")
        
        let summary1 = "Join millions of players worldwide as you build your village, raise a clan, and compete in epic Clan Wars!"
        let summary2 = "Assemble the greatest team of monsters for strategic victories!"
        let summary3 = "Join your friends in a brand new 5v5 MOBA showdown against real human opponents, Mobile Legends: Bang Bang!"
        let summary4 = "Assassin's Creed: Origins is the tenth game in the series. The story takes place in Ancient Egypt during Cleopatra's rule."
        let summary5 = "Divinity: Original Sin II is the sequel to Divinity: Original Sin. It is praised as one of the bst RPGs of all time."
        let summary6 = "Undertale tells the story of a child who has fallen Underground, into a region filled with monsters and quests. An RPG, all choices made affect the dialogue, characters, and the outcome of the story."
        let summary7 = "The latest game in the Wolfenstein series takes place in Nazi-occupied USA soon after the events of Wolfenstein: The New Order."
        let summary8 = "The sequel to South Park: The Stick of Truth, this story follows the New Kid, who has now become involved with the role-playing taking place between two superhero factions."
        let summary9 = "Match blocks and overcome challenges in this addictive puzzle with rich visual effects that unfolds a narrative through breathtaking places includign lush jungles and stormy seas."
        let summary10 = "A new kind of Mario game that you can play with one hand"
        
        
        guard let game1 = Game(name: "Clash of Clans", photo: photo1, rating: 4, summary: summary1, favorite: false)
            else {
                fatalError("Unable to instantiate game1")
        }
        guard let game2 = Game(name: "Summoners War", photo: photo2, rating: 5, summary: summary2, favorite: false)
            else {
                fatalError("Unable to instantiate game2")
        }
        guard let game3 = Game(name: "Mobile Legends", photo: photo3, rating: 3, summary: summary3, favorite: false)
            else {
                fatalError("Unable to instantiate game3")
        }
        guard let game4 = Game(name: "Assassin's Creed: Origins", photo: photo4, rating:3, summary: summary4, favorite: false)
            else {
                fatalError("Unable to instantiate game4")
        }
        guard let game5 = Game(name: "Divinity: Original Sin 2", photo: photo5, rating: 5, summary: summary5, favorite: false)
            else {
                fatalError("Unable to instantiate game5")
        }
        guard let game6 = Game(name: "Undertale", photo: photo6, rating: 5, summary: summary6, favorite: false)
            else {
                fatalError("Unable to instantiate game 6")
        }
        guard let game7 = Game(name: "Wolfenstein II", photo: photo7, rating: 3, summary: summary7, favorite: false)
            else {
                fatalError("Unable to instantiate game 7")
        }
        guard let game8 = Game(name: "South Park: The Fractured but Whole", photo: photo8, rating: 4, summary: summary8, favorite: false)
            else {
                fatalError("Unable to instantiate game 8")
        }
        guard let game9 = Game(name: "Kensho", photo: photo9, rating: 2, summary: summary9, favorite: false)
            else {
                fatalError("Unable to instantiate game 9")
        }
        guard let game10 = Game(name: "Super Mario Run", photo: photo10, rating: 3, summary: summary10, favorite: false)
            else {
                fatalError("Unable to instantiate game 10")
        }
        
        games += [game1, game2, game3, game4, game5, game6, game7, game8, game9, game10]
        sortGames()
    }
    
    
    
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
        let _ = NSKeyedArchiver.archiveRootObject(favoriteGames, toFile: Game.ArchiveURL2.path)
            }
    
    private func sortFavorites() {
        favoriteGames = favoriteGames.sorted{ $0.name < $1.name}
    }
    
    private func loadFavorites() -> [Game]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Game.ArchiveURL2.path) as? [Game]
    }
    
    private func isFavoriteAlready(_ game: Game) ->Bool {
        for ind in 0..<favoriteGames.count {
            if favoriteGames[ind].name == game.name {
                return true
            }
        }
        return false
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredGames = games.filter({(game : Game) -> Bool in
            return game.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
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
