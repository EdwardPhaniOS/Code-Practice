//
//  TableView+Dequeueing.swift
//  Case_Study
//
//  Created by Vinh Phan on 18/1/25.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let id = String(describing: T.self)
        return self.dequeueReusableCell(withIdentifier: id) as! T
    }
}
