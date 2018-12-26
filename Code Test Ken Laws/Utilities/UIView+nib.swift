//
//  UIView+nib.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/18/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit


/// A set of extensions to simplify the loading of views from a .xib file.
///
public extension UIView {

	var firstResponder:UIView? {
		if self.isFirstResponder {
			return self
		}
		for view in self.subviews {
			if let firstResponder = view.firstResponder {
				return firstResponder
			}
		}
		return nil
	}

	public class func fromNib(_ nibNameOrNil: String? = nil) -> Self {
		return fromNib(nibNameOrNil, type: self)
	}


	public class func fromNib<T : UIView>(_ nibNameOrNil: String? = nil, type: T.Type) -> T {
		let v: T? = fromNib(nibNameOrNil, type: T.self)
		return v!
	}


	public class func fromNib<T : UIView>(_ nibNameOrNil: String? = nil, type: T.Type) -> T? {
		var view: T?
		let name: String
		if let nibName = nibNameOrNil {
			name = nibName
		} else {
			// Most nibs are demangled by practice, if not, just declare string explicitly
			name = nibName
		}
		let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
		for v in nibViews! {
			if let tog = v as? T {
				view = tog
			}
		}
		return view
	}


	public class var nibName: String {
		let name = "\(self)".components(separatedBy: ".").first ?? ""
		return name
	}


	public class var nib: UINib? {
		if let _ = Bundle.main.path(forResource: nibName, ofType: "nib") {
			return UINib(nibName: nibName, bundle: nil)
		} else {
			return nil
		}
	}


}
