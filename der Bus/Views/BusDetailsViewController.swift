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
    
    
    var busDetailsList: [BusInfoDetails]? {
        didSet {
            self.busCountInfo.text = viewModel.busCountInfo
        }
    }
    
    var viewModel: BusListViewModel!
    
    var sortviewModel: SortViewModel!
    var filterviewModel: FilterViewModel!
    
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
    
    var optionsView: OptionsView!

    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc func handleSortTapped() {
        optionsView = .none
        optionsView = createOptionsModalView()
        optionsView.optionType = .sort
        optionsView.sortoptions = SortEngine.availableSortOptions()
        optionsView.allowMultipleSelections = false
        optionsView.lastSelectedSortOption = viewModel.currentlySelectedSortOption
        showModalOptionsView()
        print("Sort Tapped")
    }
    
    @objc func handleFilterTapped() {
        optionsView = .none
        optionsView = createOptionsModalView()
        optionsView.optionType = .filter
        optionsView.filteroptions = FilterEngine.availableFilterOptions()
        optionsView.allowMultipleSelections = true
        optionsView.lastSelectedFilterOptions = viewModel.currentlySelectedFilterOption
        showModalOptionsView()
        print("Filter Tapped")
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
        
        busDetailsTV.separatorStyle = .none
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
    
    fileprivate func createOptionsModalView() -> OptionsView {
        let view = OptionsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }
    
    fileprivate func showModalOptionsView() {
        view.addSubview(visualEffectView)
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        visualEffectView.alpha = 0
        
        view.addSubview(optionsView)
        
        optionsView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        optionsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        optionsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        optionsView.heightAnchor.constraint(equalToConstant: view.frame.height / 3).isActive = true
 
        optionsView.isHidden = true
        optionsView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            
            self.visualEffectView.alpha = 1
            self.optionsView.alpha = 1
            self.optionsView.isHidden = false
            self.optionsView.center.y -= self.view.bounds.height
        }, completion: nil)
    }
    
    func handleOptionsDismissal() {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.optionsView.alpha = 0
            self.optionsView.isHidden = true
            self.optionsView.center.y += self.view.bounds.height
        }) { (_) in
            self.optionsView.removeFromSuperview()
            print("Did remove pop up window..")
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
                self?.busDetailsList = self?.viewModel.busDetails
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                if (self?.viewModel.numberOfCells ?? 0) > 0 {
                    self?.busDetailsTV.separatorStyle = .singleLine
                }
                self?.busDetailsTV.reloadData()
            }
        }
        
        sortviewModel.sortedList = {[weak self] in
            if let mself = self {
                mself.viewModel.busDetails = mself.sortviewModel.busDetails
            }
        }
        
        filterviewModel.filteredList = {[weak self] in
            if let mself = self {
                mself.viewModel.busDetails = mself.filterviewModel.busDetails
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

extension BusDetailsViewController: OptionsDelegate {
    func filterOptionSelected(options: [FilterOptions]) {
        viewModel.currentlySelectedFilterOption = options
        if let busDetails = viewModel.rawBusDetailsList?.busDetails {
            filterviewModel?.fetchFilteredData(for: busDetails, with: options)
        }
        print("Filter option seletec : \(options)")
    }
    
    func sortOptionSelected(options: SortOptions) {
        viewModel.currentlySelectedSortOption = options
        if let busDetails = viewModel.rawBusDetailsList?.busDetails {
            sortviewModel?.fetchSortedData(for: busDetails, with: options)
        }
        print("Sort option seletec : \(options)")
    }
    
    func handleDismissal() {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.optionsView.alpha = 0
            self.optionsView.isHidden = true
            self.optionsView.center.y += self.view.bounds.height
        }) { (_) in
            self.optionsView.removeFromSuperview()
            self.visualEffectView.removeFromSuperview()
            self.optionsView = .none
        }
    }
}
