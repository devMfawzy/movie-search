import UIKit
import SDWebImage

class SearchViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var overviewStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 5
        posterImageView.layer.masksToBounds = true
    }

    func configureWith(_ movie: Movie) {
        self.posterImageView.sd_setImage(with: movie.poster, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        self.titleLabel.text = movie.title
        self.releaseDateLabel.text = movie.releaseDate
        guard let overview = movie.overview, !overview.isEmpty else {
            overviewStackView.isHidden = true
            return
        }
        overviewStackView.isHidden = false
        self.overviewLabel.text = overview
    }
    
}
