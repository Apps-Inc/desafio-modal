//
//  DetailView.swift
//  desafio-modal
//
//  Created by DIOGO OLIVEIRA NEISS on 08/12/21.
//

import UIKit

class DetailView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */



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
        let nib = UINib(nibName: "DetailView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        guard let view = view else { return self.view }
        return view
    }


}

