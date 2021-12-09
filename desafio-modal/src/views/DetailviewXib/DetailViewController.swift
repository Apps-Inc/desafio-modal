//
//  DetailViewController.swift
//  desafio-modal
//
//  Created by FRANCISCO SAMUEL DA SILVA MARTINS on 09/12/21.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    static let identifier = "DetailViewController"
    private let disposeBag = DisposeBag()

    var viewModel: FilterViewModel?
    weak var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
