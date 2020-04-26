import UIKit

extension UISearchBar {
    
    /**
     The text field associated to search bar, using the value coding key "searchField"
     */
    var textField: UITextField? {
        return value(forKey: "searchField") as? UITextField
    }
    
    /**
     set the backgrounf color of the associated text field
     - Parameter color: the color to be set as background
     */
    func setTextFieldBackgroundColor(_ color: UIColor) {
        guard let textField = textField else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default:
            textField.backgroundColor = color
        @unknown default:
            break
        }
    }
    
}
