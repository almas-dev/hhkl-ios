//
// Created by Alexey Korolev on 02.02.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import UIKit
import Localize_Swift
import SnapKit
import ATRSlideSelectorView

class MatchViewController: ParentViewController {

    let viewModel: MatchViewModelProtocol

    init(viewModel: MatchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    let tableView = UITableView()
    let matchHeaderView = MatchHeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "match-view-controller-title".localized()
        view.backgroundColor = UIColor.whiteColor()

        view.addSubview(tableView)
        tableView.snp_makeConstraints {
            $0.edges.equalTo(0)
        }

        tableView.dataSource = self
        tableView.registerClass(MatchSectionResultViewCell.self, forCellReuseIdentifier: String(MatchSectionResultViewCell))
        tableView.separatorStyle = .None
        tableView.rowHeight = 44
        tableView.tableHeaderView = matchHeaderView
        matchHeaderView.snp_makeConstraints {
            make in
            make.width.equalTo(tableView)
            make.height.equalTo(120)
        }
        matchHeaderView.setNeedsLayout()
        matchHeaderView.layoutIfNeeded()
        tableView.tableHeaderView = matchHeaderView
        tableView.tableFooterView = UIView()
    }

    private var matchesResultArray = [(Int, Int)]()
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        guard let match = viewModel.match else {
            return
        }
        matchHeaderView.yellowNameLabel.text = match.yellow.name
        matchHeaderView.redNameLabel.text = match.red.name

        matchesResultArray = [(Int, Int)]()
        if let scoreArray = match.score where !scoreArray.isEmpty {
            let resultMatch = scoreArray.getResultOfMatch()
            matchHeaderView.scoreLabel.text = "\(resultMatch.yellow) : \(resultMatch.red)"

            var resultGame = scoreArray[0]
            matchesResultArray += [(resultGame.yellow, resultGame.red)]
            if scoreArray.count > 1 {
                resultGame = scoreArray[1]
                matchesResultArray += [(resultGame.yellow, resultGame.red)]
                if scoreArray.count > 2 {
                    resultGame = scoreArray[2]
                    matchesResultArray += [(resultGame.yellow, resultGame.red)]
                }
            }
        } else {
            matchHeaderView.scoreLabel.text = "match-view-controller-vernus".localized()
        }
        tableView.reloadData()
    }
}

extension MatchViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.matchesResultArray.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "match-view-controller-first-section-title".localized()
        case 1:
            return "match-view-controller-second-section-title".localized()
        case 2:
            return "match-view-controller-third-section-title".localized()
        default:
            return nil
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(MatchSectionResultViewCell), forIndexPath: indexPath) as! MatchSectionResultViewCell
        let (yellow, red) = self.matchesResultArray[indexPath.section]
        if yellow > red {
            cell.sliderView.currentRatio = CGFloat(yellow + (9 - red)) / 19.0
        } else {
            cell.sliderView.currentRatio = CGFloat(yellow) / 19.0
        }
        return cell
    }

}
