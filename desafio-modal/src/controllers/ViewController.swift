import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    static let indentifier = "ViewController"

    @IBOutlet weak var filtrosStackView: UIStackView!
    @IBOutlet weak var gitCollectionView: UICollectionView!
    @IBOutlet weak var botao: UIButton!
    private let disposeBag = DisposeBag()

    var viewModel: GitRepositoryViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "teste"
        gitCollectionView.register(UINib(nibName: GitCollectionViewCell.identifier, bundle: nil),
                                   forCellWithReuseIdentifier: GitCollectionViewCell.identifier)

        addFiltro(name: "Estrela")
        addFiltro(name: "Seguidores")
        addFiltro(name: "Data")
        addFiltro(name: "decrescente")

        view.addSubview(UIButton())

        setUpView()
    }

    func addFiltro(name: String) {
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 10)

        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(name, attributes: container )
        configuration.image = UIImage(systemName: "multiply",
                                      withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        configuration.imagePlacement = .trailing

        let newFilter = UIButton(configuration: configuration, primaryAction: nil)
        newFilter.tintColor = .black
        newFilter.setTitleColor(.black, for: .normal)
        newFilter.backgroundColor = .clear
        newFilter.layer.borderWidth = 1
        newFilter.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        newFilter.layer.cornerRadius = 2
        newFilter.addTarget(self, action: #selector(removeFilter(sender:)), for: .touchUpInside)
        filtrosStackView.addArrangedSubview(newFilter)
    }

    @objc func removeFilter(sender: UIButton) {
//        sender.isHidden = true
        print("clicou")
        filtrosStackView.removeArrangedSubview(sender)
        filtrosStackView.addArrangedSubview(sender)
        sender.alpha = 0
        sender.isEnabled = false
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

//        botao.rx.tap
//            .bind {[weak self] in self?.viewModel?.openFilterView?()}
//            .disposed(by: disposeBag)
    }
}

extension ViewController: FilterDelegate {
    func onFilterApply() {
        navigationController?.dismiss(animated: true)
    }
}
