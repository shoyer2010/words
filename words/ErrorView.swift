
import Foundation
import UIKit

class ErrorView: UILabel {
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(view: UIView, message: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 25))
        self.backgroundColor = Color.red
        self.layer.opacity = 0
        self.text = message
        self.font = UIFont(name: Fonts.kaiti, size: CGFloat(16))
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        paragraphStyle.lineSpacing = 0
        paragraphStyle.alignment = NSTextAlignment.Center
        var attributes = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: self.font,
            NSForegroundColorAttributeName: Color.white,
            NSStrokeWidthAttributeName: NSNumber(float: -1.5)
            ])
        self.attributedText = NSAttributedString(string: self.text!, attributes: attributes)
        view.addSubview(self)
        
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.layer.opacity = 0.9
            }) { (isDone: Bool) -> Void in
                UIView.animateWithDuration(0.8, delay: 2, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.layer.opacity = 0
                    }) { (isDone: Bool) -> Void in
                        self.removeFromSuperview()
                }
        }
    }
}