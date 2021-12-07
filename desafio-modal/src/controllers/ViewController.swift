import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gitCollectionView: UICollectionView!
    @IBOutlet weak var filtrosStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        gitCollectionView.delegate = self
        gitCollectionView.dataSource = self
        gitCollectionView.register(UINib(nibName: GitCollectionViewCell.identifier, bundle: nil),
                                   forCellWithReuseIdentifier: GitCollectionViewCell.identifier)

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
