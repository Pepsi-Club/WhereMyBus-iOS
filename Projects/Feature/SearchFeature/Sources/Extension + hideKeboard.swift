import UIKit

extension UIViewController {
    func hideKeyboard() {
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(UIViewController.dismissKeyboard)
            )
        )
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
