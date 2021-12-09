//
//  LowerButton.swift
//  desafio-modal
//
//  Created by FRANCISCO SAMUEL DA SILVA MARTINS on 08/12/21.
//

import UIKit

class LowerButton: UIView {
    var view: UIView!
    static let identifier = "LowerButton"
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
        let nib = UINib(nibName: LowerButton.identifier, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        guard let view = view else { return self.view }
        return view
    }

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

}
