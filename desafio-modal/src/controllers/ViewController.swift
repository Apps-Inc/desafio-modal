import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gitCollectionView: UICollectionView!
    @IBOutlet weak var filtrosStackView: UIStackView!

    var activeButtons = Set<FilterButton>()

    override func viewDidLoad() {
        super.viewDidLoad()
        gitCollectionView.delegate = self
        gitCollectionView.dataSource = self
        gitCollectionView.register(UINib(nibName: GitCollectionViewCell.identifier, bundle: nil),
                                   forCellWithReuseIdentifier: GitCollectionViewCell.identifier)

        FilterButton.allCases.forEach { button in
            activeButtons.insert(button)
            createFilterButton(name: button.name, enabled: true)
        }
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
//        sender.isHidden = true
        print("clicou")
        filtrosStackView.removeArrangedSubview(sender)
        filtrosStackView.addArrangedSubview(sender)
        sender.alpha = 0
        sender.isEnabled = false
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: GitCollectionViewCell.identifier, for: indexPath)
                as? GitCollectionViewCell else {fatalError()}

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }

}
