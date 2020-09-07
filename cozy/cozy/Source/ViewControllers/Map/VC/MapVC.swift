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

    private var selectIdx: Int = 1
    private var backView = UIView()

    private var mapList: [MapListData] = []

    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(selectEvent(_:)), name: .dismissSlideView, object: nil)
    }

    @objc func selectEvent(_ notification: NSNotification) {
        let getIdx = notification.object as! Int
        self.selectIdx = getIdx
        self.getMapListData()
        self.backView.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()

        let nibName = UINib(nibName: "BookListCell", bundle: nil)
        mapTableView.register(nibName, forCellReuseIdentifier: mapIdentifier2)
        mapTableView.delegate = self
        mapTableView.dataSource = self

        getMapListData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let index = self.mapTableView.indexPathForSelectedRow {
            self.mapTableView.deselectRow(at: index, animated: true)
        }
    }

    @objc func selectRegionButton() {
        let storybaord = UIStoryboard(name: "Map", bundle: nil)
        let pvc = storybaord.instantiateViewController(identifier: "MapSelectVC") as! MapSelectVC

        pvc.transitioningDelegate = self
        pvc.modalPresentationStyle = .custom

        self.backView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)

        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        window?.addSubview(backView)
        self.backView.isHidden = false
        present(pvc, animated: true, completion: nil)
    }

    private func getMapListData() {
        MapListService.shared.getMapListData(mapIdx: self.selectIdx+1) { NetworkResult in
            switch NetworkResult {
            case .success(let data):
                guard let data = data as? [MapListData] else { return }
                self.mapList.removeAll()
                for data in data {
                    self.mapList.append(MapListData(bookstoreIdx: data.bookstoreIdx ?? 0, bookstoreName: data.bookstoreName ?? "", location: data.location ?? "", hashtag1: data.hashtag1 ?? "", hashtag2: data.hashtag2 ?? "", hashtag3: data.hashtag3 ?? "", mainImg: data.hashtag3 ?? "", checked: data.checked ?? 0))
                }
                self.mapTableView.reloadData()
            case .requestErr:
                print("Request error")
            case .pathErr:
                print("path error")
            case .serverErr:
                print("server error")
            case .networkFail:
                print("network error")
            }
        }
    }
}

extension MapVC: UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }

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
            return self.mapList.count
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
            cell.selectionStyle = .none
            cell.selectRegionButton1.addTarget(self, action: #selector(selectRegionButton), for: .touchUpInside)
            cell.selectRegionButton2.addTarget(self, action: #selector(selectRegionButton), for: .touchUpInside)

            switch self.selectIdx {
            case 0:
                cell.selectRegionButton1.setTitle("용산구", for: .normal)
            case 1:
                cell.selectRegionButton1.setTitle("마포구", for: .normal)
            case 2 :
                cell.selectRegionButton1.setTitle("관악구, 영등포구, 강서구", for: .normal)
            case 3 :
                cell.selectRegionButton1.setTitle("광진구, 노원구, 성북구", for: .normal)
            case 4:
                cell.selectRegionButton1.setTitle("서초구, 강남구, 송파구", for: .normal)
            case 5:
                cell.selectRegionButton1.setTitle("서대문구, 종로구", for: .normal)
            default:
                cell.selectRegionButton1.setTitle("마포구", for: .normal)
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: mapIdentifier2) as! BookListCell
            cell.selectionStyle = .none

            cell.bookStoreImageView.image = UIImage(named: "asdfdghfgjhj")
            cell.nameLabel.text = self.mapList[indexPath.row].bookstoreName
            cell.addressLabel.text = self.mapList[indexPath.row].location

            cell.tag1.setTitle("    #베이커리    ", for: .normal)
            cell.tag2.setTitle("    #심야책방    ", for: .normal)
            cell.tag3.setTitle("    #맥주    ", for: .normal)

            return cell
        }
    }
}

class HalfSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            guard let theView = containerView else {
                return CGRect.zero
            }
            return CGRect(x: 0, y: theView.bounds.height-563, width: theView.bounds.width, height: 563)
        }
    }
}
