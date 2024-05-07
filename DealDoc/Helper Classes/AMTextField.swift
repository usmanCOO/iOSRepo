//
//  AMTextField.swift
//  AtlasMask
//
//  Created by Asad Khan on 5/19/22.
//


import UIKit

fileprivate let _leftImagePaddingDefault: CGFloat = 18

class AMTextField: UITextField {
    
    /// Info label that is shown for a user. This label will appear under the text field.
    /// You can use it to configure appearance.
    public private(set) lazy var infoLabel = UILabel()
    
    
    @IBInspectable var translationKey: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        if let key = self.translationKey {
//            self.placeholder = LocalizedString(key, comment: "")
//        } else {
//            assertionFailure("Translation not set for \(self.placeholder ?? "")")
//        }
//
//        if RKLocalization().getlanguageDirection() == .leftToRight
//        {
//            self.textAlignment = NSTextAlignment.left
//            self.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
//
//
//        }
//        else
//        {
//            self.textAlignment = NSTextAlignment.right
//            self.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
//        }
    }
    
    var errorText = ""
    var emptyErrorText = ""
    
    var hasErrorMessage: Bool = false {
        didSet {
            if hasErrorMessage {
                showError()
            } else {
                hideError()
            }
        }
    }
    
    /// Animation duration for showing and hiding the info label.
    @IBInspectable public var infoAnimationDuration: Double = 0.4
    
    /// Color of info text.
    //Change Color Accordingly
    var infoTextColor: UIColor = UIColor.red
    var infoFontSize: CGFloat = 14.0
    var imageView: UIImageView?
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = _leftImagePaddingDefault {
        didSet {
            updateView()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initializeSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeSetup()
    }
    
    func updateView() {
        //crosButton.addTarget(self, action: #selector(crosButtonTapped), for: .touchUpInside)
        if #available(iOS 10, *) {
            // Disables the password autoFill accessory view.
            textContentType = UITextContentType(rawValue: "")
        }
        
        if let image = leftImage {
            leftViewMode = .always
            imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
            imageView?.image = image
            imageView?.contentMode = .scaleAspectFit
            imageView?.tintColor = UIColor.gray
            
            let width = leftPadding + 30
            if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line {
                //width = width + (RKLocalization().getlanguageDirection() == .leftToRight ? 12 : 0)
            }
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 30))
            view.addSubview(imageView!)
            leftView = view
            
        } else
        {
            leftViewMode = .never
        }
    }
    
    func setBorder() {
        // Change According to Need
        // layer.borderColor = UIColor.lightGray.cgColor
        // layer.borderWidth = 2
        // layer.cornerRadius = 10
    }
    
    var padding: UIEdgeInsets {
        get {
//            if leftImage != nil {
//                if RKLocalization().getlanguageDirection() == .leftToRight
//                {
//                    
//                return UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 5)
//                    
//                }
//                else
//                {
//                    return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 50)
//                }
//            }
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    /// Shows info label with/without animation.
    /// - Parameters:
    ///   - text: Custom text to show.
    ///   - animated: By default is `true`.
    public func showError(_ text: String, animated: Bool = true) {
        guard animated else {
            infoLabel.text = text
            return
        }
        
        UIView.transition(with: infoLabel, duration: infoAnimationDuration, options: [.transitionCrossDissolve], animations: {
            self.infoLabel.alpha = 1
            self.infoLabel.text = text
        })
    }
    
    public func showError() {
        UIView.transition(with: infoLabel, duration: infoAnimationDuration, options: [.transitionCrossDissolve], animations: {
            self.infoLabel.alpha = 1
            self.infoLabel.text = (self.text?.isEmpty ?? true) ? self.emptyErrorText : self.errorText
        })
    }
    
    /// Hides the info label with animation or not.
    /// - Parameter animated: By default is `true`.
    public func hideError(animated: Bool = true) {
        guard animated else {
            infoLabel.alpha = 0
            return
        }
        
        UIView.animate(withDuration: infoAnimationDuration) {
            self.infoLabel.alpha = 0
        }
    }
    
    private func initializeSetup() {
        plugInfoLabel()
        setBorder()
    }
    
    private func plugInfoLabel() {
        guard infoLabel.superview == nil else {
            return
        }
        
        infoLabel.textColor = infoTextColor
        infoLabel.font = infoLabel.font.withSize(infoFontSize)
        //  infoLabel.font.withSize(infoFontSize)
        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            infoLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 2)
        ])
    }
    
    var onEmpty: EmptyEvent?
    
}
