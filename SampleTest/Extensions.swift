//
//  Extensions.swift
//  SampleTest
//
//  Created by differenz189 on 23/02/22.
//

import UIKit

extension UIScreen {
    
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

extension UIView {
    
    func addShadow(radius:CGFloat = 4, opacity:Float = 0.5,offset:CGSize = .zero, color:CGColor = UIColor.lightGray.cgColor, viewRadius:CGFloat = 8) {
        self.layer.cornerRadius = viewRadius
        self.layer.shadowColor = color
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
        
    }
    
      func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }
    
    
    func setConstraints(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
     var topInset = CGFloat(0)
     var bottomInset = CGFloat(0)
     
     if #available(iOS 11, *), enableInsets {
     let insets = self.safeAreaInsets
     topInset = insets.top
     bottomInset = insets.bottom     
//     print(“Top: \(topInset)”)
//     print(“bottom: \(bottomInset)”)
     }
     
     translatesAutoresizingMaskIntoConstraints = false
     
     if let top = top {
     self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
     }
     if let left = left {
     self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
     }
     if let right = right {
     rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
     }
     if let bottom = bottom {
     bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
     }
     if height != 0 {
     heightAnchor.constraint(equalToConstant: height).isActive = true
     }
     if width != 0 {
     widthAnchor.constraint(equalToConstant: width).isActive = true
     }
     
     }
}


extension UIViewController {
    
    func setActionSheet(Title:String = "", Message:String, actions:[UIAlertAction]) {
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: .actionSheet)
        for act in actions {
            alert.addAction(act)
        } // loop action over
        alert.popoverPresentationController?.sourceView = UIView()
        present(alert, animated: true, completion: nil)
    } //Func Over
    
    func showAlert(alertTitle:String = "",alertMSG:String) {
        
        let alert = UIAlertController(title: alertTitle, message: alertMSG, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        alert.view.tintColor = .orange
        self.present(alert, animated: true, completion: nil)
    } // func Over
}
