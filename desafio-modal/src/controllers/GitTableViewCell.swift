//
//  GitCollectionViewCell.swift
//  desafio-modal
//
//  Created by FRANCISCO SAMUEL DA SILVA MARTINS on 06/12/21.
//

import UIKit

class GitTableViewCell: UITableViewCell {
    enum ColorType {
        case white, black
    }

    static let identifier = "GitTableViewCell"
    @IBOutlet weak var repositoryLabel: UILabel!
    @IBOutlet weak var gitImage: UIImageView!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var labelExtra: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottonView: UIView!

    func updateColor(type: ColorType) {
        if type == .black {
            topView.backgroundColor = UIColor(named: "GreyTableCell")
            bottonView.backgroundColor = UIColor(named: "BlackTableCell")
            changeTextColor(color: .white)
        } else {
            topView.backgroundColor = UIColor(named: "WhiteTableCell")
            bottonView.backgroundColor = UIColor(named: "LightGreyTableCell")
            changeTextColor(color: .black)
        }
    }

    private func changeTextColor(color: UIColor) {
        repositoryLabel.textColor = color
        starCountLabel.textColor = color
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
