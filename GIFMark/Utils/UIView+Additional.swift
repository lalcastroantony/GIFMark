//
//  UIView+Additional.swift
//  GIFMark
//
//  Created by Lal Castro on 15/07/22.
//

import Foundation
import UIKit

extension UIView {
    func heightCoveredByKeyboardOfSize(keyboardSize: CGSize) -> CGFloat {
        let frameInWindow = convert(bounds, to: nil)
        guard let windowBounds = window?.bounds else { return 0 }
        
        let keyboardTop = windowBounds.size.height - keyboardSize.height
        let viewBottom = frameInWindow.origin.y + frameInWindow.size.height
        
        return max(0, viewBottom - keyboardTop)
    }
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    func withBgColor(color: UIColor) -> UIView {
        self.backgroundColor = color
        return self
    }

    
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        self.layer.add(animation, forKey: convertFromCATransitionType(CATransitionType.fade))
    }
  
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func removeRoundedCorners() {
        self.layer.mask = nil
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATransitionType(_ input: CATransitionType) -> String {
    return input.rawValue
}

extension UIView{
    
    @discardableResult
    func centerXAlign(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        guard let view = getView(with) else{
            return self
        }
        let constraint = self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func centerYAlign(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        guard let view = getView(with) else{
            return self
        }
        let constraint = self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func leadingSpace(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        guard let view = getView(with) else{
            return self
        }
        let constraint = self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func leadingSpaceGreater(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        guard let anchor = with as? NSLayoutXAxisAnchor ?? getView(with)?.leadingAnchor else{
            return self
        }
        let constraint = self.leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func trailingSpace(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        guard let view = getView(with) else{
            return self
        }
        let constraint = self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func topSpace(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        guard let view = getView(with) else{
            return self
        }
        let constraint = self.topAnchor.constraint(equalTo: view.topAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func bottomSpace(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        guard let view = getView(with) else{
            return self
        }
        let constraint = self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func widthConstraint(constant: CGFloat, priority: UILayoutPriority = .required)->UIView{
        let constraint = self.widthAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func heightConstraint(constant: CGFloat, priority: UILayoutPriority = .required)->UIView{
        let constraint = self.heightAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func horizontalSpacing(with: Any? = nil, constant: CGFloat=0, priority: UILayoutPriority = .required)->UIView{
        guard let _ = getView(with) else{
            return self
        }
        return self.leadingSpace(constant: constant, priority: priority).trailingSpace(constant: -constant, priority: priority)
    }
    
    @discardableResult
    func verticalSpacing(with: Any? = nil, constant: CGFloat=0, priority: UILayoutPriority = .required)->UIView{
        guard let _ = getView(with) else{
            return self
        }
        return self.topSpace(constant: constant, priority: priority).bottomSpace(constant: -constant, priority: priority)
    }
    
    @discardableResult
    func spaceAround(with: Any? = nil, constant: CGFloat=0, priority: UILayoutPriority = .required)->UIView{
        guard let _ = getView(with) else{
            return self
        }
        translatesAutoresizingMaskIntoConstraints = false
        return self.topSpace(constant: constant, priority: priority).bottomSpace(constant: -constant, priority: priority).leadingSpace(constant: constant, priority: priority).trailingSpace(constant: -constant, priority: priority)
    }
    
    @discardableResult
    func alignCenter(with: Any? = nil, priority: UILayoutPriority = .required)->UIView{
        return self.centerXAlign(with: with, priority: priority).centerYAlign(with: with, priority: priority)
    }
    
    @discardableResult
    func getView(_ with: Any?)->UIView?{
        if let view = with as? UIView{
            return view
        }
        else{
            return self.superview
        }
    }
}

extension UIView{
    //guide
    
    @discardableResult
    func centerXAlign(withConstraint: UILayoutGuide, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        let constraint = self.centerXAnchor.constraint(equalTo: withConstraint.centerXAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func centerYAlign(withConstraint: UILayoutGuide, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        let constraint = self.centerYAnchor.constraint(equalTo: withConstraint.centerYAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func leadingSpace(withConstraint: UILayoutGuide, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        let constraint = self.leadingAnchor.constraint(equalTo: withConstraint.leadingAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func trailingSpace(withConstraint: UILayoutGuide, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        let constraint = self.trailingAnchor.constraint(equalTo: withConstraint.trailingAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func topSpace(withConstraint: UILayoutGuide, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        let constraint = self.topAnchor.constraint(equalTo: withConstraint.topAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func bottomSpace(withConstraint: UILayoutGuide, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        let constraint = self.bottomAnchor.constraint(equalTo: withConstraint.bottomAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func horizontalSpacing(withConstraint: UILayoutGuide, constant: CGFloat=0, priority: UILayoutPriority = .required)->UIView{
        return self.leadingSpace(withConstraint: withConstraint, constant: constant, priority: priority).trailingSpace(withConstraint: withConstraint, constant: -constant, priority: priority)
    }
    
    @discardableResult
    func verticalSpacing(withConstraint: UILayoutGuide, constant: CGFloat=0, priority: UILayoutPriority = .required)->UIView{
        return self.topSpace(withConstraint: withConstraint, constant: constant, priority: priority).bottomSpace(withConstraint: withConstraint, constant: -constant, priority: priority)
    }
    
    @discardableResult
    func spaceAround(withConstraint: UILayoutGuide, constant: CGFloat=0, priority: UILayoutPriority = .required)->UIView{
        translatesAutoresizingMaskIntoConstraints = false
        return self.topSpace(withConstraint: withConstraint, constant: constant, priority: priority).bottomSpace(withConstraint: withConstraint, constant: -constant, priority: priority).leadingSpace(withConstraint: withConstraint, constant: constant, priority: priority).trailingSpace(withConstraint: withConstraint, constant: -constant, priority: priority)
    }
    
    @discardableResult
    func alignCenter(withConstraint: UILayoutGuide, priority: UILayoutPriority = .required)->UIView{
        return self.centerXAlign(withConstraint: withConstraint, priority: priority).centerYAlign(withConstraint: withConstraint, priority: priority)
    }
}


extension UIView{
    
    //constraint
    @discardableResult
    func centerXAlign(with: NSLayoutXAxisAnchor, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        let constraint = self.centerXAnchor.constraint(equalTo: with, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func centerYAlign(with: NSLayoutYAxisAnchor, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        let constraint = self.centerYAnchor.constraint(equalTo: with, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func leadingSpace(with: NSLayoutXAxisAnchor, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        let constraint = self.leadingAnchor.constraint(equalTo: with, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func trailingSpace(with: NSLayoutXAxisAnchor, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        let constraint = self.trailingAnchor.constraint(equalTo: with, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func  topSpace(with: NSLayoutYAxisAnchor, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        let constraint = self.topAnchor.constraint(equalTo: with, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    @discardableResult
    func bottomSpace(with: NSLayoutYAxisAnchor, constant: CGFloat = 0, priority: UILayoutPriority = .required)->UIView{
        let constraint = self.bottomAnchor.constraint(equalTo: with, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }
    
    func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .clear) {
        
        let customShadowLayerName: String = "custom_shadow_layer"
        
        if let subLayers = layer.sublayers {
            let layersToRemove = subLayers.filter { layer in
                return layer.name == customShadowLayerName
            }
            for layer in layersToRemove {
                layer.removeFromSuperlayer()
            }
        }
        
        let shadowLayer = CAShapeLayer()
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
        shadowLayer.name = customShadowLayerName
        shadowLayer.path = cgPath //2
        shadowLayer.fillColor = fillColor.cgColor //3
        shadowLayer.shadowColor = shadowColor.cgColor //4
        shadowLayer.shadowPath = cgPath
        shadowLayer.shadowOffset = offSet //5
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
        self.layer.insertSublayer(shadowLayer, below: nil)
    }

    
}

extension UIView {

  var safeTopAnchor: NSLayoutYAxisAnchor {
    if #available(iOS 11.0, *) {
      return self.safeAreaLayoutGuide.topAnchor
    }
    return self.topAnchor
  }

  var safeLeftAnchor: NSLayoutXAxisAnchor {
    if #available(iOS 11.0, *){
      return self.safeAreaLayoutGuide.leftAnchor
    }
    return self.leftAnchor
  }

  var safeRightAnchor: NSLayoutXAxisAnchor {
    if #available(iOS 11.0, *){
      return self.safeAreaLayoutGuide.rightAnchor
    }
    return self.rightAnchor
  }

  var safeBottomAnchor: NSLayoutYAxisAnchor {
    if #available(iOS 11.0, *) {
      return self.safeAreaLayoutGuide.bottomAnchor
    }
    return self.bottomAnchor
  }
}
extension UIView {

    func removeConstraints() { removeConstraints(constraints) }
    func deactivateAllConstraints(onlySubview: Bool) { NSLayoutConstraint.deactivate(getAllConstraints(onlySubview: onlySubview)) }
    func getAllSubviews() -> [UIView] { return UIView.getAllSubviews(view: self) }

    func getAllConstraints(onlySubview: Bool) -> [NSLayoutConstraint] {
        var subviewsConstraints = getAllSubviews().flatMap { $0.constraints }
        if onlySubview == false {
            if let superview = self.superview {
                subviewsConstraints += superview.constraints.compactMap { (constraint) -> NSLayoutConstraint? in
                    if let view = constraint.firstItem as? UIView, view == self { return constraint }
                    return nil
                }
            }
        }
        return subviewsConstraints + constraints
    }

    class func getAllSubviews(view: UIView) -> [UIView] {
        return view.subviews.flatMap { [$0] + getAllSubviews(view: $0) }
    }
    
    class func getOpaqueSubviews(view:UIView) -> [UIView] {
        var subviews = [UIView]()

        for subview in view.subviews {
            subviews += getOpaqueSubviews(view: subview)

            if let bgColor = subview.backgroundColor, bgColor != .clear {
                subviews.append(subview)
            }
        }

        return subviews
    }
}
