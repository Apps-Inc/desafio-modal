import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    static let indentifier = "ViewController"
    private let disposeBag = DisposeBag()
    var viewModel: GitRepositoryViewModel?

    @IBOutlet weak var gitTableView: UITableView!
    @IBOutlet weak var filtrosStackView: UIStackView!
    var activeButtons = Set<FilterButton>()

    override func viewDidLoad() {
        super.viewDidLoad()
        gitTableView.register(UINib(nibName: GitTableViewCell.identifier, bundle: nil),
                              forCellReuseIdentifier: GitTableViewCell.identifier)

        FilterButton.allCases.forEach { button in
            activeButtons.insert(button)
            createFilterButton(name: button.name, enabled: true)
        }

        setUpView()
    }

    func createFilterButton(name: String, enabled: Bool = false) {
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 10)

        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(name, attributes: container)
        configuration.image = UIImage(systemName: "multiply",
                                      withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        configuration.imagePlacement = .trailing

        let newButton = UIButton(configuration: configuration, primaryAction: nil)
        newButton.tintColor = .black
        newButton.setTitleColor(.black, for: .normal)
        newButton.backgroundColor = .clear
        newButton.layer.borderWidth = 1
        newButton.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        newButton.layer.cornerRadius = 2
        newButton.addTarget(self, action: #selector(disableFilterButton(sender:)), for: .touchUpInside)
        newButton.titleLabel?.numberOfLines = 1

        filtrosStackView.addArrangedSubview(newButton)

        if !enabled {
            disableFilterButton(sender: newButton)
        }
    }

    @objc func disableFilterButton(sender: UIButton) {
        filtrosStackView.removeArrangedSubview(sender)
        filtrosStackView.addArrangedSubview(sender)
        sender.alpha = 0
        sender.isEnabled = false
    }

    private func setUpView() {
        guard let viewModel = viewModel else { return }

        viewModel.updateRepositoryList()
        viewModel.allRepositories
            .bind(to: gitTableView.rx.items(
                cellIdentifier: GitTableViewCell.identifier, cellType: GitTableViewCell.self)) { _, _, _ in
                // TODO: bind
            }
            .disposed(by: disposeBag)
    }
}

extension ViewController: FilterDelegate {
    func onFilterApply() {
        navigationController?.dismiss(animated: true)
    }
}
