import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    var movie: MovieModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }

    func setupScreen() {
        guard let movie = movie else {
            return
        }

        // Loading the movie poster
        if let posterURL = URL(string: movie.poster ?? "") {
            URLSession.shared.dataTask(with: posterURL) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.movieImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }

        // Setting up the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView() // Hide empty cells
    }

    @IBAction func plotButtonTapped(_ sender: UIButton) {
            let plotViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlotViewController") as! PlotViewController
            plotViewController.movie = movie
            plotViewController.ratings = movie?.ratings // Set the ratings property
            navigationController?.pushViewController(plotViewController, animated: true)
        

    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 22 // Number of fields in MovieModel
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)

        // Configuring the cell
        if let movie = movie {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Title"
                cell.detailTextLabel?.text = movie.title
            case 1:
                cell.textLabel?.text = "Year"
                cell.detailTextLabel?.text = movie.year
            case 2:
                cell.textLabel?.text = "Rated"
                cell.detailTextLabel?.text = movie.rated
            case 3:
                cell.textLabel?.text = "Released"
                cell.detailTextLabel?.text = movie.released
            case 4:
                cell.textLabel?.text = "Runtime"
                cell.detailTextLabel?.text = movie.runtime
            case 5:
                cell.textLabel?.text = "Genre"
                cell.detailTextLabel?.text = movie.genre
            case 6:
                cell.textLabel?.text = "Director"
                cell.detailTextLabel?.text = movie.director
            case 7:
                cell.textLabel?.text = "Writer"
                cell.detailTextLabel?.text = movie.writer
            case 8:
                cell.textLabel?.text = "Actors"
                cell.detailTextLabel?.text = movie.actors
            case 9:
                cell.textLabel?.text = "Language"
                cell.detailTextLabel?.text = movie.language
            case 10:
                cell.textLabel?.text = "Country"
                cell.detailTextLabel?.text = movie.country
            case 11:
                cell.textLabel?.text = "Awards"
                cell.detailTextLabel?.text = movie.awards
            case 12:
                cell.textLabel?.text = "Response"
                cell.detailTextLabel?.text = movie.response
            case 13:
                cell.textLabel?.text = "Metascore"
                cell.detailTextLabel?.text = movie.metascore
            case 14:
                cell.textLabel?.text = "IMDb Rating"
                cell.detailTextLabel?.text = movie.imdbRating
            case 15:
                cell.textLabel?.text = "IMDb Votes"
                cell.detailTextLabel?.text = movie.imdbVotes
            case 16:
                cell.textLabel?.text = "IMDb ID"
                cell.detailTextLabel?.text = movie.imdbID
            case 17:
                cell.textLabel?.text = "Type"
                cell.detailTextLabel?.text = movie.type
            case 18:
                cell.textLabel?.text = "DVD"
                cell.detailTextLabel?.text = movie.dvd
            case 19:
                cell.textLabel?.text = "Box Office"
                cell.detailTextLabel?.text = movie.boxOffice
            case 20:
                cell.textLabel?.text = "Production"
                cell.detailTextLabel?.text = movie.production
            case 21:
                cell.textLabel?.text = "Website"
                cell.detailTextLabel?.text = movie.website
            default:
                break
            }
        }

        return cell
    }
}
