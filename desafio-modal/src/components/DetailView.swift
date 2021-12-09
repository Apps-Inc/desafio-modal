//
//  DetailView.swift
//  desafio-modal
//
//  Created by DIOGO OLIVEIRA NEISS on 08/12/21.
//

import UIKit

class DetailView: UIView {

    @IBOutlet weak var repoImage: UIImageView!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var commitsLabel: UILabel!
    @IBOutlet weak var realeasesLabel: UILabel!
    @IBOutlet weak var branchsLabel: UILabel!
    @IBOutlet weak var colaboratorLabel: UILabel!
    @IBOutlet weak var readmeScrollView: UIScrollView!
    static let identifier = "DetailView"

    var view: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: DetailView.identifier, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        guard let view = view else { return self.view }
        return view
    }

}
