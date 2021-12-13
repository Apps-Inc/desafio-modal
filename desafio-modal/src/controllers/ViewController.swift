import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet var searchBar: UIStackView!
    @IBOutlet weak var viewBackgroundRadius: UIView!
    static let identifier = "ViewController"
    private let disposeBag = DisposeBag()

    var viewModel: GitRepositoryViewModel?
    weak var coordinator: AppCoordinator?

    @IBOutlet weak var viewRadius: UIView!
    @IBOutlet weak var gitTableView: UITableView!
    @IBOutlet weak var filtrosStackView: UIStackView!
    var activeButtons = Set<FilterButton>()
    var buttons: [FilterButton: UIButton] = [:]
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewRadius?.roundTop(viewName: searchBar)

        gitTableView.register(UINib(nibName: GitTableViewCell.identifier, bundle: nil),
                              forCellReuseIdentifier: GitTableViewCell.identifier)

        FilterButton.allCases.forEach { label in
            createFilterButton(name: label, enabled: false)
        }

        setupNavigationBar()
        setUpTableView()
        setUpFilterView()
        setUpSearch()

        refreshControl.attributedTitle = NSAttributedString(string: "Puxe para atualizar")

        refreshControl.addTarget(self, action: #selector(refreshOnPullToLoad(_:)), for: .valueChanged)

        self.gitTableView.addSubview(refreshControl)

    }

    @objc func refreshOnPullToLoad(_ sender: AnyObject) {
        guard let viewModel = viewModel else { return }

        viewModel.updateRepositoryList()

        self.gitTableView.reloadData()
        self.refreshControl.endRefreshing()
    }

    func setUpSearch() {
        guard let viewModel = viewModel else { return }
        searchInput.rx
                .controlEvent([.editingChanged])
                .asObservable()
                .subscribe {[weak searchInput, viewModel] _ in
                    viewModel.filterName.onNext(searchInput?.text ?? "")
                }
                .disposed(by: disposeBag)

        viewModel.filterName.bind(to: searchInput.rx.text)
            .disposed(by: disposeBag)

    }

    func setupNavigationBar() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self,
                                                            action: #selector(search))
        let filterButton = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                            action: #selector(openFilter))
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        searchButton.tintColor = .white
        filterButton.tintColor = .white
        backButton.tintColor = .white

        navigationItem.rightBarButtonItems = [filterButton, searchButton]
        navigationItem.backBarButtonItem = backButton
        navigationItem.title = "Github"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    @objc func openFilter() {
        coordinator?.openFilter()
    }

    @objc func search() {
        searchBar.isHidden = searchBar.isHidden ? false : true
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
        viewModel?.filterName.onNext("")
    }

    func enableFilterButton(button: UIButton, label: String? = nil, atIndex: Int = 0) {
        filtrosStackView.removeArrangedSubview(button)
        filtrosStackView.insertArrangedSubview(button, at: atIndex)
        button.alpha = 1
        button.isEnabled = true
        if let label = label {
            button.setTitle(label, for: .normal)
        }
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
        viewModel.repositories
            .bind(to: gitTableView.rx.items(
                cellIdentifier: GitTableViewCell.identifier, cellType: GitTableViewCell.self)) { idx, repo, cel in
                    cel.updateColor(type: idx % 2 == 0 ? .black : .white)
                    cel.repositoryLabel.text = repo.name
                    cel.followersLabel.text = String(repo.watchers)
                    cel.followersLabel.text = String(repo.watchers)
                    cel.starCountLabel.text = String(repo.stargazersCount)
                    cel.dataLabel.text =
                            """
                                \(Calendar.current.dateComponents([.day],
                                from: repo.createdAt,
                                to: Date()).day!) dias
                            """
            }
            .disposed(by: disposeBag)

        gitTableView.rx.modelSelected(RepositoryDetails.self)
            .subscribe { [weak coordinator] repo in
                coordinator?.openDetails(repository: repo)
            }
          .disposed(by: disposeBag)
    }

    private func setUpFilterView() {
        viewModel?.filters
            .subscribe { [weak self] res in
                guard let filterOptions = res.element else { return }
                let filters = filterOptions.filters
                let order = filterOptions.order

                self?.buttons.forEach {(key, value) in
                    if filters.contains(key) {
                        self?.enableFilterButton(button: value)
                    } else {
                        self?.disableFilterButton(button: value)
                    }
                }

                if let order = order,
                   let button = self?.buttons[.order] {
                    self?.enableFilterButton(button: button, label: order.rawValue, atIndex: filters.count)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension ViewController: FilterDelegate {
    func onFilterApply() {
        navigationController?.dismiss(animated: true)
    }
}
