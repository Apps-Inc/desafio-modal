import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    static let indentifier = "ViewController"

    @IBOutlet weak var gitCollectionView: UICollectionView!
    @IBOutlet weak var botao: UIButton!
    private let disposeBag = DisposeBag()

    var viewModel: GitRepositoryViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "teste"
        gitCollectionView.register(UINib(nibName: GitCollectionViewCell.identifier, bundle: nil),
                                   forCellWithReuseIdentifier: GitCollectionViewCell.identifier)

        view.addSubview(UIButton())

        setUpView()
    }

    private func setUpView() {
        guard let viewModel = viewModel else { return }

        viewModel.updateRepositoryList()
        viewModel.allRepositories
            .bind(to: gitCollectionView.rx.items(
                cellIdentifier: GitCollectionViewCell.identifier, cellType: GitCollectionViewCell.self)) { _, _, _ in
                // TODO: bind
            }
            .disposed(by: disposeBag)

        botao.rx.tap
            .bind {[weak self] in self?.viewModel?.openFilterView?()}
            .disposed(by: disposeBag)
    }
}

extension ViewController: FilterDelegate {
    func onFilterApply() {
        navigationController?.dismiss(animated: true)
    }
}
