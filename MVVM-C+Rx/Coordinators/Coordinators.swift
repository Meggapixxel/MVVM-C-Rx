//
//  Coordinators.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 08.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import Foundation

struct Coordinators {

    let base: P_Coordinator
    
    init(base: P_Coordinator) {
        self.base = base
    }
    
}

extension P_Coordinator {
    
    var coodinators: Coordinators { Coordinators(base: self) }
    
}
