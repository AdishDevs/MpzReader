//
//  ContentsVC.swift
//  MenuItemKit
//
//  Created by Hasitha Mapalagama on 8/24/19.
//

import Foundation
import UIKit
import R2Shared
import R2Navigator

protocol MpzContentsDelegate {
    func contentRequest(navigateTo locator : Locator)
}
class MpzContentsVC : UIViewController {
    static func create(withPub publication: Publication, delegate : MpzContentsDelegate) -> MpzContentsVC {
        let stry = UIStoryboard.init(name: "Main", bundle: Bundle.init(for: HighlightListVC.self))
        let vc = stry.instantiateViewController(withIdentifier: "content_vc") as! MpzContentsVC
        vc.publication = publication
        vc.delegate = delegate
        return vc
    }
    
    @IBOutlet weak var tableView: UITableView!
    var delegate : MpzContentsDelegate?
    var publication : Publication!
    var links = [(level: Int, link: Link)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.links = flatten(publication.tableOfContents)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    func flatten(_ links: [Link], level: Int = 0) -> [(level: Int, link: Link)] {
        return links.flatMap { [(level, $0)] + flatten($0.children, level: level + 1) }
    }
}

extension MpzContentsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.links.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let link = self.links[indexPath.item]
        let spaces = [0...link.level].reduce(" ", {a, _ in return "\(a) "})
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.font = UIFont(name: MpzReader.configs.fontName, size: 17)
        cell.textLabel?.text = "\(spaces)\(link.link.title ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = self.links[indexPath.item]
        let locator = Locator.init(link: link.link)
        self.delegate?.contentRequest(navigateTo: locator)
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
