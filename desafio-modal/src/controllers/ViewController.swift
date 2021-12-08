import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gitTableView: UITableView!
    @IBOutlet weak var filtrosStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        gitTableView.delegate = self
        gitTableView.dataSource = self
        gitTableView.register(UINib(nibName: GitTableViewCell.identifier, bundle: nil),
                              forCellReuseIdentifier: GitTableViewCell.identifier)

        addFiltro(name: "Estrela")
        addFiltro(name: "Seguidores")
        addFiltro(name: "Data")
        addFiltro(name: "decrescente")
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

        filtrosStackView.removeArrangedSubview(sender)
        filtrosStackView.addArrangedSubview(sender)
        sender.alpha = 0
        sender.isEnabled = false
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: GitTableViewCell.identifier, for: indexPath)
                as? GitTableViewCell else {fatalError()}

        return cell
    }

}
