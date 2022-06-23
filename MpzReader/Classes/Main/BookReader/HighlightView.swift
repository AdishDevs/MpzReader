//
//  HighlightView.swift
//  MenuItemKit
//
//  Created by Hasitha Mapalagama on 8/22/19.
//
import Foundation
import UIKit
class HightlightView : UIViewController {
    
    static func create(withHighlight highlight : Highlight) -> HightlightView {
        let stry = UIStoryboard.init(name: "Main", bundle: Bundle.init(for: HightlightView.self))
        let vc = stry.instantiateViewController(withIdentifier: "highlight_vc") as! HightlightView
        vc.preferredContentSize = CGSize.init(width: 220, height: 35)
        vc.popoverPresentationController?.permittedArrowDirections = .down
        vc.highlight = highlight
        return vc
    }
    
    var onChangeColor : ((_ highlight : Highlight) -> Void)?
    var onRemove : ((_ highlight : Highlight) -> Void)?
    var highlight : Highlight!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.popoverPresentationController?.backgroundColor = .black
    }
    
    
    @IBAction func didClickColor(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            highlight.color = "#C9FB53"
        case 2:
            highlight.color = "#84ABFF"
        case 3:
            highlight.color = "#F47CB8"
        case 4:
            highlight.color = "#FAFB0A"
        default:
            highlight.color = "#C9FB53"
        }
        
        self.onChangeColor?(highlight)
        
    }
    
    @IBAction func didDelete(_ sender: Any) {
        self.onRemove?(highlight)
    }
    
}

