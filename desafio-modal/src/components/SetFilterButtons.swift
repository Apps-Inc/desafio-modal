//
//  SetFilterButton.swift
//  desafio-modal
//
//  Created by LUCAS ALLAN ALMEIDA OLIVEIRA on 06/12/21.
//

import UIKit

class SetFilterButton: UIView {
    var view: UIView!
    var filtros = ["CRESCENTE"]
    @IBOutlet var decrescente: UIButton!
    @IBOutlet var crescente: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        crescente.isSelected = true
        formatButtonSelected(button: crescente)
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
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
    
        return view
    }
    
  
    @IBAction func filterButtons(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        button.isSelected = button.isSelected ? false : true
        
        if button.isSelected {
            filtros.append(button.currentTitle!)
            formatButtonSelected(button: button)
        } else {
            let index = filtros.firstIndex(of: button.currentTitle!)
            filtros.remove(at: index!)
            formatButtonUnSelected(button: button)
        }
        print(filtros)
    }
    
    
    @IBAction func orderFilter(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        if button.isSelected { return }
        button.isSelected = true
        
        if button.currentTitle! == "CRESCENTE" {
            filtros.append(button.currentTitle!)
            let index = filtros.firstIndex(of: "DECRESCENTE")
            filtros.remove(at: index!)
            formatButtonSelected(button: crescente)
            formatButtonUnSelected(button: decrescente)
            decrescente.isSelected = false
        } else {
            filtros.append(button.currentTitle!)
            let index = filtros.firstIndex(of: "CRESCENTE")
            filtros.remove(at: index!)
            formatButtonSelected(button: decrescente)
            formatButtonUnSelected(button: crescente)
            crescente.isSelected = false
        }
        print(filtros)
    }
    
    func formatButtonSelected(button: UIButton) {
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .selected)
        button.setImage(UIImage(systemName: "checkmark"), for:.selected)
    }
    
    func formatButtonUnSelected(button: UIButton) {
        button.backgroundColor = .white
        button.titleLabel?.textColor = .black
        button.setImage(UIImage(named: ""), for: .normal)
    }
    
}
