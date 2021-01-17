//
//  ViewController.swift
//  Argylist
//
//  Created by Gytis Tumas on 2021-01-16.
//

import UIKit

class LinkItemsViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var tableViewBottom: NSLayoutConstraint!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.isHidden = true
        }
    }
    @IBOutlet private var nextPageButton: UIButton! {
        didSet {
            nextPageButton.isEnabled = false
        }
    }
    @IBOutlet private var previousPageButton: UIButton! {
        didSet {
            previousPageButton.isEnabled = false
        }
    }
    private var searchBar = UISearchBar()
    var linkItemPage: LinkItemPage?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        searchBar.delegate = self
        setupUI()
        updateUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
    }

    private func setupUI() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // Animate the tableView height for showing/hiding the keyboard
    @objc func adjustForKeyboard(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions().rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            tableViewBottom.constant = endFrame?.height ?? 0
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    private func updateUI() {
        nextPageButton.isEnabled = linkItemPage?.nextPageURL != nil
        previousPageButton.isEnabled = linkItemPage?.previousPageURL != nil
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails",
           let linkItemsDetailsViewController = segue.destination as? LinkItemDetailsViewController,
           let urlString = sender as? String {
            linkItemsDetailsViewController.urlString = urlString
        }
    }

    // MARK: - Fetching

    private func getLinkItems(withURL url: String) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        APIService.shared.getLinkItems(withURL: url) { (result) in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            switch result {
            case .success(let linkItemPage):
                self.linkItemPage = linkItemPage
                self.updateUI()
            case .failure(let error):
                self.showAlert(error.errorDescription ?? "")
            }
        }
    }

    // MARK: - Actions

    @IBAction func nextPageTapped(sender: UIButton) {
        guard let nextPageURL = linkItemPage?.nextPageURL else {
            return
        }
        getLinkItems(withURL: nextPageURL)
    }

    @IBAction func previousPageTapped(sender: UIButton) {
        guard let previousPageURL = linkItemPage?.previousPageURL else {
            return
        }
        getLinkItems(withURL: previousPageURL)
    }
}

extension LinkItemsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let linkItems = linkItemPage?.linkItems, !linkItems.isEmpty {
            tableView.hideEmptyState()
            return linkItems.count
        } else {
            let emptyStateMessage = searchBar.text!.isEmpty ? "Search for companies and platforms" : "No items found"
            tableView.showEmptyState(with: emptyStateMessage)
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LinkItemCell", for: indexPath) as? LinkItemCell else {
            fatalError("Couldn't dequeue LinkItemCell")
        }
        if let linkItems = linkItemPage?.linkItems {
            let linkItem = linkItems[indexPath.row]
            cell.setup(with: linkItem)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let linkItems = linkItemPage?.linkItems {
            let linkItem = linkItems[indexPath.row]
            performSegue(withIdentifier: "showDetails", sender: linkItem.loginURL)
        }
    }

}

extension LinkItemsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            linkItemPage = nil
            updateUI()
            return
        }
        let url = APIService.shared.url(forSearchText: searchText)
        getLinkItems(withURL: url)
    }
}
