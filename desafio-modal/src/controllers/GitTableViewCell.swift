//
//  GitCollectionViewCell.swift
//  desafio-modal
//
//  Created by FRANCISCO SAMUEL DA SILVA MARTINS on 06/12/21.
//

import UIKit

class GitTableViewCell: UITableViewCell {
    static let identifier = "GitTableViewCell"
    @IBOutlet weak var repositoryLabel: UILabel!
    @IBOutlet weak var gitImage: UIImageView!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var labelExtra: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottonView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
