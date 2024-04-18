//
//  PlotViewController.swift
//  MovieApp
//
//  Created by user238852 on 09/04/24.
//

import UIKit

class PlotViewController: UIViewController {

    @IBOutlet weak var ratingsTextView: UITextView!
    @IBOutlet weak var plotTextView: UITextView!
    @IBOutlet weak var addToWatchlistButton: UIButton!

    var movie: MovieModel?
    var ratings: [MovieModel.Rating]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }

    func setupScreen() {
        guard let movie = movie else {
              return
          }

        // Setting up the text views
        ratingsTextView.text = formattedRatings()
        plotTextView.text = movie.plot

        
    }


    @IBAction func addToWatchlistButtonTapped(_ sender: UIButton) {
        
        guard let selectedMovie = movie else {
                return
            }

            if WatchlistManager.shared.isMovieInWatchlist(movie: selectedMovie) {
               
                showPopupAlert(message: "Movie is already added to watchlist.")
            } else {
               
                WatchlistManager.shared.addToWatchlist(movie: selectedMovie)
                showPopupAlert(message: "Movie Added to Watchlist: \(selectedMovie.title ?? "")")
            }
    }
    
    func formattedRatings() -> String {
        guard let ratings = movie?.ratings else {
            return "Ratings unavailable"
        }

        var formattedText = ""
        for rating in ratings {
            if let source = rating.Source, let value = rating.Value {
                formattedText += "\(source): \(value)\n"
            } else {
               
            }
        }

        return formattedText.isEmpty ? "Ratings unavailable" : formattedText
    }



        func showPopupAlert(message: String) {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }


