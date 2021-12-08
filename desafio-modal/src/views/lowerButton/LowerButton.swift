//
//  LowerButton.swift
//  desafio-modal
//
//  Created by LUCAS ALLAN ALMEIDA OLIVEIRA on 08/12/21.
//

import UIKit

class LowerButton: UIView {
    @IBOutlet var button: UIButton!
    var view: UIView!

    static let identifier = "LowerButton"

    override func awakeFromNib() {

    }

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

    func changeButtonTitle(title: String) {
        button.setTitle(title, for: .normal)
    }
}
