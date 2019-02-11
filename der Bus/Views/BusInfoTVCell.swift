//
//  BusInfoTVCell.swift
//  der Bus
//
//  Created by Shantanu Dutta on 10/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import UIKit

class BusInfoTVCell: UITableViewCell {
    
    @IBOutlet weak var busLogo: UIImageView!
    @IBOutlet weak var travelName: UILabel!
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    
    @IBOutlet weak var featuresLabel: UILabel!
    
    @IBOutlet weak var FareView: UIView!
    @IBOutlet weak var fareLabel: UILabel!
    
    var viewModel: BusListCellViewModel! {
        didSet {
            configureVM()
        }
    }
    
    private func configureVM() {
        viewModel.imageData.bind { [weak self] (value) in
            if let imageData = value, let image = UIImage(data: imageData) {
                OperationQueue.main.addOperation {
                    self?.busLogo.image = image
                }
            }
        }
        viewModel.travelerName.bind { [weak self] (value) in
            OperationQueue.main.addOperation {
                self?.travelName.text = value
            }
        }
        viewModel.departureTime.bind { [weak self] (value) in
            OperationQueue.main.addOperation {
                self?.departureTime.text = value
            }
        }
        viewModel.arrivalTime.bind { [weak self] (value) in
            OperationQueue.main.addOperation {
                self?.arrivalTime.text = value
            }
        }
        viewModel.ratingLabel.bind { [weak self] (value) in
            OperationQueue.main.addOperation {
                self?.ratingLabel.text = value
            }
        }
        viewModel.ratingCountLabel.bind { [weak self] (value) in
            OperationQueue.main.addOperation {
                self?.ratingCountLabel.text = value
            }
        }
        viewModel.featuresLabel.bind { [weak self] (value) in
            OperationQueue.main.addOperation {
                self?.featuresLabel.text = value
            }
        }
        viewModel.fareLabel.bind { [weak self] (value) in
            OperationQueue.main.addOperation {
                self?.fareLabel.text = value
            }
        }
    }
}
