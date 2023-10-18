//
//  HeroTableViewCell.swift
//  DragonBall
//
//  Created by Gabriel Castro on 18/10/23.
//

import UIKit
import Kingfisher

class HeroCellView: UITableViewCell {
    static let identifier: String = "HeroCellView"
    static let estimatedHeight: CGFloat = 256
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroPhoto: UIImageView!
    @IBOutlet weak var heroDescription: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()

        heroName.text = nil
        heroPhoto.image = nil
        heroDescription.text = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 8
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.4

        heroPhoto.layer.cornerRadius = 8
        heroPhoto.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]

        selectionStyle = .none
    }

    func updateView(
        name: String? = nil,
        photo: String? = nil,
        description: String? = nil
    ) {
        self.heroName.text = name
        self.heroDescription.text = description
        self.heroPhoto.kf.setImage(with: URL(string: photo ?? ""))
    }
}

