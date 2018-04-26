//
//  Namable.swift
//  Move
//
//  Created by Jake Gray on 4/26/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import Foundation

@objc protocol Nameable: class {
    var name: String { get set }
}
