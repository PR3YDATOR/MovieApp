//
//  WatchlistViewController.swift
//  MovieApp
//
//  Created by user238852 on 09/04/24.
//


import UIKit

class WatchlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var watchlistTableView: UITableView!

    // Using WatchlistManager to manage the watchlist
    var watchlist: [MovieModel] {
        return WatchlistManager.shared.getWatchlist()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }

    func setupScreen() {
        watchlistTableView.delegate = self
        watchlistTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlist.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Set the desired height for the cell
        return 150 // Adjust this value according to your preference
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "watchlistCell", for: indexPath)

        let movie = watchlist[indexPath.row]

        // Configuring the cell with movie information
        cell.textLabel?.text = movie.title

        // Loading the movie poster
        if let posterURL = URL(string: movie.poster ?? "") {
            URLSession.shared.dataTask(with: posterURL) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: data)
                        cell.setNeedsLayout()
                    }
                }
            }.resume()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = watchlist[indexPath.row]

        // Instantiating the DetailViewController
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController

        // Passing the selected movie to the detail view controller
        detailViewController.movie = selectedMovie

        // Pushing the detail view controller to the navigation stack
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Removing the movie from the watchlist and update the table view
            let removedMovie = watchlist[indexPath.row]
            WatchlistManager.shared.removeFromWatchlist(movie: removedMovie)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
