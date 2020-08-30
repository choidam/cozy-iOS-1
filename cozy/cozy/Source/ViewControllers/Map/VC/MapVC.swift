//
//  MapVC.swift
//  cozy
//
//  Created by 최은지 on 2020/08/18.
//  Copyright © 2020 최은지. All rights reserved.
//

import UIKit

class MapVC: UIViewController {

    private let mapIdentifier1: String = "mapSelectCell"
    private let mapIdentifier2: String = "bookListCell"

    @IBOutlet weak var mapTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "BookListCell", bundle: nil)
        mapTableView.register(nibName, forCellReuseIdentifier: mapIdentifier2)
        mapTableView.delegate = self
        mapTableView.dataSource = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let index = self.mapTableView.indexPathForSelectedRow {
            self.mapTableView.deselectRow(at: index, animated: true)
        }
    }

    @objc func selectRegionButton() {
        print("click!")
    }

}

extension MapVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "BookDetail", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "BookDetailVC") as! BookDetailVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 5
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 106
        } else {
            return 370
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: mapIdentifier1) as! MapSelectCell
            cell.selectRegionButton1.addTarget(self, action: #selector(selectRegionButton), for: .touchUpInside)
            cell.selectRegionButton2.addTarget(self, action: #selector(selectRegionButton), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: mapIdentifier2) as! BookListCell

            cell.bookStoreImageView.image = UIImage(named: "asdfdghfgjhj")
            cell.nameLabel.text = "코지서점"
            cell.addressLabel.text = "서울특별시 용산구 한강대로 10길"

            cell.tag1.setTitle("    #베이커리    ", for: .normal)
            cell.tag2.setTitle("    #심야책방    ", for: .normal)
            cell.tag3.setTitle("    #맥주    ", for: .normal)

            return cell
        }
    }
}
