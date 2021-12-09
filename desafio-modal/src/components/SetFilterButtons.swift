//
//  SetFilterButton.swift
//  desafio-modal
//
//  Created by LUCAS ALLAN ALMEIDA OLIVEIRA on 06/12/21.
//

import UIKit

protocol SetFilterDelegate: AnyObject {
    func aplicar(filtros: [FilterButton], ordem: Order?)
}

class SetFilterButtons: UIView {
    var view: UIView!
//    var filtros = [String]()
    @IBOutlet var seguidores: UIButton!
    @IBOutlet var decrescente: UIButton!
    @IBOutlet var data: UIButton!
    @IBOutlet var estrelas: UIButton!
    @IBOutlet var crescente: UIButton!

    weak var delegate: SetFilterDelegate?

    override func awakeFromNib() {
        initialButtonFormat(buttons: [decrescente, crescente, estrelas, seguidores, data])
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
        let nib = UINib(nibName: "SetFilterButtons", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        guard let view = view else { return self.view }
        return view
    }

    @IBAction func filterButtons(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        button.isSelected = button.isSelected ? false : true

        formatButton(button: button)
//        if button.isSelected {
////            filtros.append(button.currentTitle!)
//            formatButtonSelected(button: button)
//        } else {
////            let index = filtros.firstIndex(of: button.currentTitle!)
////            filtros.remove(at: index!)
//            formatButtonUnSelected(button: button)
//        }
    }

    @IBAction func orderFilter(_ sender: Any) {
        guard let button = sender as? UIButton else { return }

        if !decrescente.isSelected && !crescente.isSelected {
//            filtros.append(button.currentTitle!)
            formatButtonSelected(button: button)
            button.isSelected = true
            return
        }

        if button.isSelected {
            removeBotaoOrdenacao(item: button.currentTitle!, button: button)
            return
        }

        button.isSelected = true

        if button.currentTitle! == "CRESCENTE" {
//            filtros.append(button.currentTitle!)
            formatButtonSelected(button: crescente)
            removeBotaoOrdenacao(item: "DECRESCENTE", button: decrescente)
        } else {
//            filtros.append(button.currentTitle!)
            formatButtonSelected(button: decrescente)
            removeBotaoOrdenacao(item: "CRESCENTE", button: crescente)
        }
    }

    func formatButton(button: UIButton) {
        if button.isSelected {
            formatButtonSelected(button: button)
        } else {
            formatButtonUnSelected(button: button)
        }
    }

    func formatButtonSelected(button: UIButton) {
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .selected)
        button.setImage(UIImage(systemName: "checkmark"), for: .selected)
    }

    func formatButtonUnSelected(button: UIButton) {
        button.backgroundColor = .white
        button.titleLabel?.textColor = .black
        button.setImage(UIImage(named: ""), for: .normal)
    }

    func initialButtonFormat(buttons: [UIButton]) {
        for button in buttons {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.cornerRadius = 5
        }
    }

    func removeBotaoOrdenacao(item: String, button: UIButton) {
//        let index = filtros.firstIndex(of: item)
//        filtros.remove(at: index!)
        formatButtonUnSelected(button: button)
        button.isSelected = false
    }

    @IBAction func applicar(_ sender: Any) {

        var ordem: Order?
        var filtros: [FilterButton] = []

        if estrelas.isSelected { filtros.append(.star) }
        if seguidores.isSelected { filtros.append(.followers) }
        if data.isSelected { filtros.append(.date) }

        if crescente.isSelected {
            ordem = .ASCENDING
        } else if decrescente.isSelected {
            ordem = .DESCENDING
        }

        delegate?.aplicar(filtros: filtros, ordem: ordem)
    }
}
