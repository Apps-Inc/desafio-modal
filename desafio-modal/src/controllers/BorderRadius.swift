//
//  BorderRadius.swift
//  desafio-modal
//
//  Created by CAIRO AUGUSTO CARVALHO DE OLIVEIRA on 10/12/21.
//

import Foundation
import UIKit

extension UIView {

//    func roundCorners(cornerRadiuns: CGFloat, typeCorners: CACornerMask) {
//        self.layer.cornerRadius = cornerRadiuns
//        self.layer.maskedCorners = typeCorners
//        self.clipsToBounds = true
//    }
    func roundTop(viewName: UIView!) {
        viewName.clipsToBounds = true
        viewName.layer.cornerRadius = 10
        viewName.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}
