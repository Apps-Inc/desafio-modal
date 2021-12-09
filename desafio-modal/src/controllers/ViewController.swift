import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    static let identifier = "ViewController"
    private let disposeBag = DisposeBag()

    var viewModel: GitRepositoryViewModel?
    weak var coordinator: AppCoordinator?

    @IBOutlet weak var gitTableView: UITableView!
    @IBOutlet weak var filtrosStackView: UIStackView!
    var activeButtons = Set<FilterButton>()
    var buttons: [FilterButton: UIButton] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        gitTableView.register(UINib(nibName: GitTableViewCell.identifier, bundle: nil),
                              forCellReuseIdentifier: GitTableViewCell.identifier)

        FilterButton.allCases.forEach { label in
            createFilterButton(name: label, enabled: false)
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                            action: #selector(openFilter))

        setUpTableView()

        viewModel?.filters
            .subscribe { [weak self] res in
                let filters = res.element?.filters ?? []

                self?.buttons.forEach {(key, value) in
                    if filters.contains(key) {
                        self?.enableFilterButton(button: value)
                    } else {
                        self?.disableFilterButton(button: value)
                    }
                }
            }
            .disposed(by: disposeBag)
    }

    @objc func openFilter() {
        coordinator?.openFilter()
    }

    func createFilterButton(name: FilterButton, enabled: Bool = false) {
        if let button = buttons[name] {
            enableFilterButton(button: button)
            return
        }

        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 10)

        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(name.name, attributes: container)
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
//        newButton.addTarget(self, action: #selector(disableFilterButton(sender:)), for: .touchUpInside)
        newButton.titleLabel?.numberOfLines = 1
        newButton.rx.tap.map { name }.subscribe {[weak viewModel] buttonType  in
            if let buttonType = buttonType.element {
                viewModel?.removeFilterItem(item: buttonType)
            }
        }
        .disposed(by: disposeBag)

        buttons[name] = newButton
        filtrosStackView.addArrangedSubview(newButton)

        if !enabled {
            disableFilterButton(button: newButton)
        }
    }
    @IBAction func cleanFilters(_ sender: Any) {
        filtrosStackView.arrangedSubviews.forEach { item in
            guard let item = item as? UIButton else {return}
            item.sendActions(for: .touchUpInside)
        }
    }

    func enableFilterButton(button: UIButton) {
        filtrosStackView.removeArrangedSubview(button)
        filtrosStackView.insertArrangedSubview(button, at: 0)
        button.alpha = 1
        button.isEnabled = true
    }

    func disableFilterButton(button: UIButton) {
        filtrosStackView.removeArrangedSubview(button)
        filtrosStackView.addArrangedSubview(button)
        button.alpha = 0
        button.isEnabled = false
    }

    private func setUpTableView() {
        guard let viewModel = viewModel else { return }

        viewModel.updateRepositoryList()
        viewModel.allRepositories
            .bind(to: gitTableView.rx.items(
                cellIdentifier: GitTableViewCell.identifier, cellType: GitTableViewCell.self)) { _, repo, cel in
                    cel.name.text = repo.name
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
