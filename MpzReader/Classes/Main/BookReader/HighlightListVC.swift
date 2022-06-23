//
//  HighlightListViewController.swift
//  MpzReader
//
//  Created by Hasitha Mapalagama on 8/23/19.
//

import Foundation
import UIKit
class HighlightCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var highlightLabel: UILabel!
    
    var highlight : Highlight! {
        didSet {
            self.dateLabel.text = ""
            self.highlightLabel.text = self.highlight.hightlightedText
            self.highlightLabel.font = UIFont(name: MpzReader.configs.fontName, size: 17)
            self.highlightLabel.backgroundColor = UIColor.init(fromHex: self.highlight.color ?? "#FFFFFF")
            self.titleLabel.text = self.highlight.resourceTitle
        }
    }
}

protocol HighlightListDelegate {
    func highlighDidClick(highlight : Highlight)
    func delegateHighlight(highlight : Highlight)
}

class HighlightListVC : UIViewController {
    
    static func create(withHightlights highlights : [Highlight], delegate : HighlightListDelegate) -> HighlightListVC {
        let stry = UIStoryboard.init(name: "Main", bundle: Bundle.init(for: HighlightListVC.self))
        let vc = stry.instantiateViewController(withIdentifier: "highlight_list_vc") as! HighlightListVC
        vc.highlights = highlights
        vc.delegate = delegate
        return vc
    }
    
    @IBOutlet weak var tableView: UITableView!
    var highlights = [Highlight]()
    var delegate : HighlightListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
}

extension HighlightListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highlights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HighlightCell
        cell.highlight = self.highlights[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.highlighDidClick(highlight: highlights[indexPath.item])
        self.navigationController?.popViewController(animated: true)
    }
}
