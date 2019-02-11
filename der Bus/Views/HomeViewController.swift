//
//  HomeViewController.swift
//  der Bus
//
//  Created by Shantanu Dutta on 10/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: UIViewController {
    
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var toView: UIView!
    
    @IBOutlet weak var fromDestination: UITextField!
    @IBOutlet weak var toDestination: UITextField!
    
    let picker = UIPickerView()
    var activeTextField = 0
    
//    var busDetailsList: BusDetailsList? {
//        didSet {
//            print("Details : \(String(describing: busDetailsList?.busDetails.count))")
//        }
//    }
    
    lazy var viewModel: HomeScreenViewModel = {
        return HomeScreenViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureVM()
        viewModel.fetchBusDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = "der Bus"
    }
    
    let routeSelectedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(">", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(handleSelectedRoute), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSelectedRoute() {
        if let fromText = fromDestination.text, let toText = toDestination.text, !fromText.isEmpty, !toText.isEmpty {
            navigationItem.title = ""
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let busDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "BusDetails") as! BusDetailsViewController
            busDetailsViewController.viewModel = BusListViewModel(APIService.create(.defaultService), fromDestination: fromText, toDestination: toText)
            busDetailsViewController.sortviewModel = SortViewModel()
            busDetailsViewController.filterviewModel = FilterViewModel()
            navigationController?.pushViewController(busDetailsViewController, animated: true)
        }else{
            SVProgressHUD.showError(withStatus: "Select From and To destination")
        }
    }
}

extension HomeViewController {
    fileprivate func configureView() {
        navigationItem.title = "der Bus"
        
        view.addSubview(routeSelectedButton)
        NSLayoutConstraint.activate([
            routeSelectedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            routeSelectedButton.topAnchor.constraint(equalTo: toDestination.bottomAnchor, constant: 50),
            routeSelectedButton.widthAnchor.constraint(equalToConstant: 50),
            routeSelectedButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        routeSelectedButton.isHidden = true
        fromDestination.delegate = self
        toDestination.delegate = self
    }
    
    fileprivate func createPickerView() {
        picker.delegate = self
        picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
        fromDestination.inputView = picker
        toDestination.inputView = picker
    }
    
    fileprivate func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(HomeViewController.closePickerView))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        fromDestination.inputAccessoryView = toolbar
        toDestination.inputAccessoryView = toolbar
    }
    
    @objc func closePickerView()
    {
        view.endEditing(true)
        if let fromText = fromDestination.text, let toText = toDestination.text, !fromText.isEmpty, !toText.isEmpty {
            UIView.animate(withDuration: 0.2) {
                self.routeSelectedButton.isHidden = false
            }
        }
    }
    
    fileprivate func configureVM() {
//        viewModel.showAlertClosure = { [weak self] in
//            DispatchQueue.main.async {
//                if let message = self?.viewModel.alertMessage {
//                    self?.showAlert( message )
//                }
//            }
//        }
//
//        viewModel.updateLoadingStatus = { [weak self] in
//            DispatchQueue.main.async {
//                let isLoading = self?.viewModel.isLoading ?? false
//                if isLoading {
//                    if !UIApplication.shared.isNetworkActivityIndicatorVisible {
//                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//                    }
//                    SVProgressHUD.show()
//                    UIView.animate(withDuration: 0.2, animations: {
//                        self?.view.alpha = 0.0
//                    })
//                }else {
//                    if UIApplication.shared.isNetworkActivityIndicatorVisible {
//                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                    }
//                    SVProgressHUD.dismiss()
//                    UIView.animate(withDuration: 0.2, animations: {
//                        self?.view.alpha = 1.0
//                    })
//                }
//            }
//        }
        
        viewModel.fetchedBusDetails = { [weak self] in
            DispatchQueue.main.async {
                self?.createPickerView()
                self?.createToolbar()
            }
        }
        
//        viewModel.fetchBusDetails()
    }
    
    func showAlert( _ message: String ) {
        SVProgressHUD.showError(withStatus: message)
    }
}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch activeTextField {
        case 1:
            return viewModel.fromDestinationList?.count ?? 0
        case 2:
            return viewModel.toDestinationList?.count ?? 0
        default:
            return  0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch activeTextField {
        case 1:
            if let list = viewModel.fromDestinationList {
                return list[row]
            }else{
                return ""
            }
        case 2:
            if let list = viewModel.toDestinationList {
                return list[row]
            }else{
                return ""
            }
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch activeTextField {
        case 1:
            if let list = viewModel.fromDestinationList {
                fromDestination.text = list[row]
            }else{
                fromDestination.text = ""
            }
        case 2:
            if let list = viewModel.toDestinationList {
                toDestination.text = list[row]
            }else{
                toDestination.text = ""
            }
        default:
            fromDestination.text = ""
            toDestination.text = ""
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case fromDestination:
            activeTextField = 1
            picker.reloadAllComponents()
        case toDestination:
            activeTextField = 2
            picker.reloadAllComponents()
        default:
            activeTextField = 0
        }
    }
}
