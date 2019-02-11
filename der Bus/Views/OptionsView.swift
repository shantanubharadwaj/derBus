//
//  OptionsView.swift
//  der Bus
//
//  Created by Shantanu Dutta on 2/11/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import UIKit

protocol OptionsDelegate {
    func filterOptionSelected(options: [FilterOptions])
    func sortOptionSelected(options: SortOptions)
    func handleDismissal()
}

private let reuseIdentifier = "OptionCell"
class OptionsView: UIView {
    
    enum OptionType {
        case sort
        case filter
        case none
    }
    
    var allowMultipleSelections = false
    
    var lastSelectedFilterOptions: [FilterOptions]?
    var lastSelectedSortOption: SortOptions?
    
    var filteroptions = [FilterOptions](){
        didSet {
            self.tableView.reloadData()
        }
    }
    var sortoptions = [SortOptions](){
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var filteroptionsselected = Set<FilterOptions>()
    var sortoptionselected: SortOptions = .Rating_HighLow
    
    var optionType: OptionType = .none {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var delegate: OptionsDelegate?
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let headerDoneButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 15)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    @objc func handleDismissal() {
        switch optionType {
        case .filter:
            delegate?.filterOptionSelected(options: Array(filteroptionsselected))
        case .sort:
            delegate?.sortOptionSelected(options: sortoptionselected)
        default:
            break
        }
        
        delegate?.handleDismissal()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        containerView.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        headerView.addSubview(headerDoneButton)
        headerDoneButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        headerDoneButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -20).isActive = true
        headerDoneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        headerView.addSubview(headerLabel)
        headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: headerDoneButton.leftAnchor, constant: 20).isActive = true
        
        containerView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        
        tableView.register(OptionsViewTvCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
    }
}


extension OptionsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch optionType {
        case .filter:
             return filteroptions.count
        case .sort:
            return sortoptions.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexpath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexpath)
        switch optionType {
        case .filter:
            cell.textLabel?.text = filteroptions[indexpath.row].getDescription()
        case .sort:
            cell.textLabel?.text = sortoptions[indexpath.row].get()
        default:
            cell.textLabel?.text = ""
        }
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if !allowMultipleSelections {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch optionType {
        case .filter:
            filteroptionsselected.insert(filteroptions[indexPath.row])
        case .sort:
            sortoptionselected = sortoptions[indexPath.row]
        default:
            break
        }
        if allowMultipleSelections {
            if let cell = tableView.cellForRow(at: indexPath) as? OptionsViewTvCell {
                if cell.cellSelected {
                    cell.accessoryType = .none
                    cell.cellSelected = false
                }else{
                    cell.accessoryType = .checkmark
                    cell.cellSelected = true
                }
                cell.isSelected = false
            }
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
}
