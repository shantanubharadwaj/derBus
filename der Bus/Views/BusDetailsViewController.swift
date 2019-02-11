//
//  BusDetailsViewController.swift
//  der Bus
//
//  Created by Shantanu Dutta on 10/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import UIKit
import SVProgressHUD

private let reuseIdentifier = "busDetailsCell"
class BusDetailsViewController: UIViewController {
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var busDetailsTV: UITableView!
    @IBOutlet weak var journeyInfo: UIView!
    @IBOutlet weak var containerView: UIView!
    
    
    var busDetailsList: BusDetailsList? {
        didSet {
            self.busCountInfo.text = viewModel.busCountInfo
        }
    }
    
    var viewModel: BusListViewModel!
    
    lazy var sortLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.font = UIFont(name: "Avenir-Heavy", size: 20)
        label.textAlignment = .center
        label.text = "Sort"
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSortTapped)))
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.darkGray.cgColor
        return label
    }()
    
    lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.font = UIFont(name: "Avenir-Heavy", size: 20)
        label.textAlignment = .center
        label.text = "Filter"
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFilterTapped)))
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.darkGray.cgColor
        return label
    }()
    
    let busCountInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Medium", size: 12)
        label.textAlignment = .center
        label.layer.borderWidth = 0.3
        label.layer.borderColor = UIColor.darkGray.cgColor
        return label
    }()
    
    @objc func handleSortTapped() {
        print("Handle Sort Tapped")
    }
    
    @objc func handleFilterTapped() {
        print("Handle Filter Tapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureVM()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchBusDetails()
    }
}

extension BusDetailsViewController {
    func configureView() {
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        
        navigationItem.title = viewModel.titleBarInfo
        
        busDetailsTV.separatorStyle = .singleLine
        busDetailsTV.separatorColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        busDetailsTV.layoutMargins = UIEdgeInsets.zero
        busDetailsTV.separatorInset = UIEdgeInsets.zero
        busDetailsTV.delegate = self
        busDetailsTV.dataSource = self
        
        sortView.addSubview(sortLabel)
        NSLayoutConstraint.activate([
            sortLabel.leftAnchor.constraint(equalTo: sortView.leftAnchor),
            sortLabel.topAnchor.constraint(equalTo: sortView.topAnchor),
            sortLabel.rightAnchor.constraint(equalTo: sortView.rightAnchor),
            sortLabel.bottomAnchor.constraint(equalTo: sortView.bottomAnchor)
            ])
        
        filterView.addSubview(filterLabel)
        NSLayoutConstraint.activate([
            filterLabel.leftAnchor.constraint(equalTo: filterView.leftAnchor),
            filterLabel.topAnchor.constraint(equalTo: filterView.topAnchor),
            filterLabel.rightAnchor.constraint(equalTo: filterView.rightAnchor),
            filterLabel.bottomAnchor.constraint(equalTo: filterView.bottomAnchor)
            ])
        
        journeyInfo.addSubview(busCountInfo)
        NSLayoutConstraint.activate([
            busCountInfo.leftAnchor.constraint(equalTo: journeyInfo.leftAnchor),
            busCountInfo.topAnchor.constraint(equalTo: journeyInfo.topAnchor),
            busCountInfo.rightAnchor.constraint(equalTo: journeyInfo.rightAnchor),
            busCountInfo.bottomAnchor.constraint(equalTo: journeyInfo.bottomAnchor)
            ])
        
        guard viewModel.isAppOnline else {
            SVProgressHUD.showError(withStatus: "Device Offline !!! Please try later ")
            return
        }
    }
    
    fileprivate func configureVM() {
        viewModel.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }

        viewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    if !UIApplication.shared.isNetworkActivityIndicatorVisible {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    }
                    SVProgressHUD.show()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.view.alpha = 0.0
                    })
                }else {
                    if UIApplication.shared.isNetworkActivityIndicatorVisible {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    SVProgressHUD.dismiss()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.view.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.fetchedBusDetails = { [weak self] in
            DispatchQueue.main.async {
                self?.busDetailsList = self?.viewModel.busDetailsList
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.busDetailsTV.reloadData()
            }
        }
    }
    
    func showAlert( _ message: String ) {
        SVProgressHUD.showError(withStatus: message)
    }
}

extension BusDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BusInfoTVCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.viewModel = viewModel.viewModelForCell(for: indexPath)
        return cell
    }
}
