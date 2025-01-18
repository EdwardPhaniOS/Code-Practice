//
//  TableView+RegisterCell.swift
//  Case_Study
//
//  Created by Vinh Phan on 18/1/25.
//

import UIKit

extension UITableView {
    
    func registerNib<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let nibName = String(describing: T.self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        self.register(nib, forCellReuseIdentifier: nibName)
    }
    
    func register<T: UITableViewCell>(cellType: T.Type) {
        let id = String(describing: T.self)
        self.register(cellType, forCellReuseIdentifier: id)
    }
    
}
