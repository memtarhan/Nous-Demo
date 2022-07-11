//
//  Nibbable.swift
//  Nous
//
//  Created by Mehmet Tarhan on 11/07/2022.
//  Copyright © 2022 MEMTARHAN. All rights reserved.
//

import UIKit

protocol Nibbable {
    static func instantiate() -> Self
}

extension Nibbable where Self: UIViewController {
    /**
     Instantiates a view controller from a nib with the same name
     */
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]

        return Self(nibName: className, bundle: nil)
    }
}
