//
//  HomeViewController.swift
//  MovieApp
//
//  Created by user238852 on 09/04/24.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    
    @IBOutlet weak var moreInfoButton: UIButton!
    
    
    @IBOutlet weak var searchButton: UIButton!


    var movie: MovieModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }

    // Setting a func that will clear the labels, image view and buttons initially
    func setupScreen() {
        movieImageView.isHidden = true
        nameLabel.isHidden = true
        yearLabel.isHidden = true
        moreInfoButton.isHidden = true

        // Setting up the navigation bar
        navigationItem.title = "Home"
        let watchlistButton = UIBarButtonItem(image: UIImage(systemName: "video"), style: .plain, target: self, action: #selector(watchlistButtonTapped))
        navigationItem.rightBarButtonItem = watchlistButton

        // Setting the UITextField delegate to self
        inputField.delegate = self

        // Adding target action for moreInfoButton
        moreInfoButton.addTarget(self, action: #selector(moreInfoButtonTapped), for: .touchUpInside)
    }

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        performSearch()
    }

    // UITextFieldDelegate method to handle return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        return true
    }

    func performSearch() {
        guard let movieName = inputField.text, !movieName.isEmpty else {
            // Showing an alert when the text field is empty
            return
        }

        // Making a network request to get the movie information
        NetworkingManager.shared.searchForMovie(title: movieName) { movie, error in
            if let error = error {
                print("Error: \(error)")
            } else if let movie = movie {
                print("Movie: \(String(describing: movie.title))")

                // Set the movie property
                self.movie = movie

                // Update UI with the movie information
                DispatchQueue.main.async {
                    self.updateScreen(with: movie)
                }
            }
        }

        // Dismiss the keyboard
        inputField.resignFirstResponder()
    }

    func updateScreen(with movie: MovieModel) {
        // Show the image view, labels, and button
        movieImageView.isHidden = false
        nameLabel.isHidden = false
        yearLabel.isHidden = false
        moreInfoButton.isHidden = false

        // Extract the required information from the movie model
        let title = movie.title ?? "N/A"
        let year = movie.year ?? "N/A"
        let posterURL = movie.poster ?? ""

        // Update UI elements with extracted information
        nameLabel.text = title
        yearLabel.text = year

        // Load the movie poster asynchronously
        if let posterURL = URL(string: posterURL) {
            URLSession.shared.dataTask(with: posterURL) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.movieImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }

    @objc func moreInfoButtonTapped() {
        // Checking if there is a movie object set in the UI
        guard let movie = movie else {
            return
        }

        // Instantiating the DetailViewController
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController

        // Passing the selected movie to the detail view controller
        detailViewController.movie = movie

        // Pushing the detail view controller to the navigation stack
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    @IBAction func watchlistButtonTapped(_ sender: UIBarButtonItem) {
        // Showing the watchlist screen
        let watchlistViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WatchlistViewController") as! WatchlistViewController
        navigationController?.pushViewController(watchlistViewController, animated: true)
    }
}
