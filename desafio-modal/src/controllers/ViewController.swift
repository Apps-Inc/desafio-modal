import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gitCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        gitCollectionView.delegate = self
        gitCollectionView.dataSource = self
        gitCollectionView.register(UINib(nibName: GitCollectionViewCell.identifier, bundle: nil),
                                   forCellWithReuseIdentifier: GitCollectionViewCell.identifier)
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
