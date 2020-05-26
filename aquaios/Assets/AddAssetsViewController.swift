import UIKit
import PromiseKit

class AddAssetsViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    private var assets: [Asset] = []
    private var filteredAssets: [Asset] = []
    private var searchController: AquaSearchController?
    private var showSearchResults = false

    override func viewDidLoad() {
        super.viewDidLoad()
        //configureSearch()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveButton.round(radius: 26.5, borderWidth: 2, borderColor: .tiffanyBlue)
        reloadData()
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.estimatedSectionHeaderHeight = 44
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.separatorColor = .black
        tableView.backgroundColor = .white
        tableView.backgroundView?.backgroundColor = .white
        let nib = UINib(nibName: "AddAssetCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AddAssetCell")
    }

    func configureSearch() {
        searchController = AquaSearchController(searchResultsController: nil, delegate: self)
        if let searchController = searchController {
            searchController.configureBar(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 48),
                                          placeholder: "Search assets...",
                                          font: UIFont.systemFont(ofSize: 18, weight: .medium),
                                          textColor: .black,
                                          tintColor: .white)
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            tableView.tableHeaderView = searchController.aquaSearchBar
        }
    }

    func reloadData() {
        self.assets = AquaService.allAssets()
        self.tableView.reloadData()
    }

    @IBAction override func dismissTapped(_ sender: Any) {
        dismissModal(animated: true)
    }

    @IBAction func saveTapped(_ sender: Any) {
        dismissModal(animated: true)
    }
}

extension AddAssetsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showSearchResults {
            return filteredAssets.count
        } else {
            return assets.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let asset = assets[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AddAssetCell") as? AddAssetCell {
            cell.configure(with: asset)
            return cell
        }
        return UITableViewCell()
    }
}

extension AddAssetsViewController: AquaSearchDelegate {
    func didTapSearch() {
    }

    func didStartSearch() {
    }

    func didTapCancel() {
    }

    func didChangeSearchTet() {
    }
}

extension AddAssetsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredAssets = assets.filter({ (asset: Asset) -> Bool in
            if let name = asset.name, let searchString = searchController.searchBar.text {
                return name.range(of: searchString) != nil
            }
            return true
        })
    }
}
