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
        viewModel.logoImageDownloadClosure = {[weak self] in
            if let imageData = self?.viewModel.imageData, let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self?.busLogo.image = image
                }
            }
        }
        
        viewModel.travelerNameClosure = {[weak self] in
            DispatchQueue.main.async {
                self?.travelName.text = self?.viewModel.travelerName
            }
        }
        
        viewModel.departureTimeClosure = {[weak self] in
            DispatchQueue.main.async {
                self?.departureTime.text = self?.viewModel.departureTime
            }
        }
        
        viewModel.arrivalTimeClosure = {[weak self] in
            DispatchQueue.main.async {
                self?.arrivalTime.text = self?.viewModel.arrivalTime
            }
        }
        
        viewModel.ratingLabelClosure = {[weak self] in
            DispatchQueue.main.async {
                self?.ratingLabel.text = self?.viewModel.ratingLabel
            }
        }
        
        viewModel.ratingCountLabelClosure = {[weak self] in
            DispatchQueue.main.async {
                self?.ratingCountLabel.text = self?.viewModel.ratingCountLabel
            }
        }
        
        viewModel.featuresLabelClosure = {[weak self] in
            DispatchQueue.main.async {
                self?.featuresLabel.text = self?.viewModel.featuresLabel
            }
        }
        
        viewModel.fareLabelClosure = {[weak self] in
            DispatchQueue.main.async {
                self?.fareLabel.text = self?.viewModel.fareLabel
            }
        }
    }
}
