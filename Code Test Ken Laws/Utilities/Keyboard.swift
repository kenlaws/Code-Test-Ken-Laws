//
//  Keyboard.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/20/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit

struct KLKeyboardParts {
	var height:CGFloat = 0
	var rate:TimeInterval = 0

	init(info: [AnyHashable : Any]?) {
		guard let info = info else { return	}
		if let rect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			self.height = rect.height
		}
		if let rate = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
			self.rate = rate
		}
	}
}

