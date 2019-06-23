//
//  SearchQuranByTopicViewController.swift
//  Quran
//
//  Created by Eyad Shokry on 2/14/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class SearchQuranByTopicViewController: UIViewController {
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var userQuerySearchBar: UISearchBar!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var versesTableView: UITableView!
    
    var menuTitles = ["Verses", "Sub-Topics", "Related Topics"]
    var versesArray = [Aya]()
    var topicVersesArray = [Ayat]()
    var subTopicsArray = [String]()
    var relatedTopicsArray = [String]()
    var selectedIndex = 0
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    var indicatorView = UIView()
    let indicatorHeight: CGFloat = 3
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    var isTopicRequest = false
    var selectedTopic = ""


    
    fileprivate func adjustMenuCollectionView() {
        menuCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredVertically)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
        
        indicatorView.backgroundColor = .brown
        indicatorView.frame = CGRect(x: menuCollectionView.bounds.minX, y: menuCollectionView.bounds.maxY - indicatorHeight, width: menuCollectionView.bounds.width / CGFloat(menuTitles.count), height: indicatorHeight)
        menuCollectionView.addSubview(indicatorView)
    }
    
    fileprivate func addNoDataLabel() {
        self.noDataLabel.center = self.view.center
        self.noDataLabel.textAlignment = .center
        self.noDataLabel.text = "No Data to show yet."
        self.noDataLabel.textColor = .gray
        self.noDataLabel.font = noDataLabel.font.withSize(20)
        self.view.addSubview(noDataLabel)
    }
    
    private func showNoDataLabel() {
        self.noDataLabel.isHidden = false
    }
    
    private func hideNoDataLabel() {
        self.noDataLabel.isHidden = true
    }
    
    fileprivate func addActivityIndicator() {
        let container: UIView = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        container.backgroundColor = .clear
        
        self.activityIndicator.center = self.view.center
        
        container.addSubview(self.activityIndicator)
        self.view.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    private func showActivityIndicator() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    fileprivate func adjustMenuAndTable(isHidden: Bool) {
        menuCollectionView.isHidden = isHidden
        versesTableView.isHidden = isHidden
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performUIUpdatesOnMain {
            self.adjustMenuCollectionView()
            self.adjustMenuAndTable(isHidden: true)
            self.addNoDataLabel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchingCell = UINib(nibName: "SearchViewCell", bundle: nil)
        self.versesTableView.register(searchingCell, forCellReuseIdentifier: "SearchCell")
    }
    
    
    @IBAction func onClickSearchButton(_ sender: UIButton) {
        performUIUpdatesOnMain {
            self.adjustMenuAndTable(isHidden: true)
            self.hideNoDataLabel()
            self.addActivityIndicator()
        }
        getAyatFromMostSimilarTopic(query: userQuerySearchBar.text!, completionHandler: {(success) -> Void in
            if success {
                self.performUIUpdatesOnMain {
                    self.hideActivityIndicator()
                    self.adjustMenuAndTable(isHidden: false)
                    self.refreshContent()
                }
            } else {
                self.performUIUpdatesOnMain {
                    self.hideActivityIndicator()
                    self.showNoDataLabel()
                }
            }
        })
    }
    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            if selectedIndex < menuTitles.count - 1 {
                selectedIndex += 1
            }
        } else {
            if selectedIndex > 0 {
                selectedIndex -= 1
            }
        }
        selectedIndexPath = IndexPath(item: selectedIndex, section: 0)
        menuCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredVertically)
        refreshContent()
    }
  
    func refreshContent() {
        versesTableView.reloadData()
        
        let desiredX = (menuCollectionView.bounds.width / CGFloat(menuTitles.count)) * CGFloat(selectedIndex)
        UIView.animate(withDuration: 0.3) {
            self.indicatorView.frame = CGRect(x: desiredX, y: self.menuCollectionView.bounds.maxY - self.indicatorHeight, width: self.menuCollectionView.bounds.width / CGFloat(self.menuTitles.count), height: self.indicatorHeight)
        }
    }
    
    
    func getAyatFromMostSimilarTopic(query: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        self.isTopicRequest = false
        Client.shared().getDataFromMostSimilarTopicsAPI(query: query, completionHandler: {(data, error) in
            if error != nil {
                self.showAlertController(withTitle: "Error fetching Ayat", withMessage: "We didn't find any Information, Be sure to be connected with Internet or try again later.")
                completionHandler(false)
            }
                
            else if let fetchedData = data {
                self.versesArray.removeAll()
                self.subTopicsArray.removeAll()
                self.relatedTopicsArray.removeAll()
                print("topicVersesArray count: \(self.topicVersesArray.count) , versesArray count: \(self.versesArray.count)")
                
                for topic in fetchedData {
                    if topic.Ranking == "1" {
                        self.selectedTopic = topic.Topic
                        for subTopic in topic.SubTopics {
                            self.subTopicsArray.append(subTopic)
                        }
                        print("This is sub topics array:")
                        print(self.subTopicsArray)
                        for aya in topic.ayat {
                            self.versesArray.append(aya)
                        }
                        print("This is versesArray:")
                        print(self.versesArray.count)
                    } else {
                        self.relatedTopicsArray.append(topic.Topic)
                    }
                }
                print("This is relatedTopicsArray:")
                print(self.relatedTopicsArray)
                completionHandler(true)
            }
        })
    }
    
    func getAyatFromTopic(topic: String, completionHandler: @escaping (_ success: Bool) -> Void){
        self.isTopicRequest = true
        Client.shared().getDataFromTopicAyatAPI(topic: topic, completionHandler: {(data, error) in
            if error != nil {
                self.showAlertController(withTitle: "Error fetching Ayat", withMessage: "We didn't find any Information, Be sure to be connected with Internet or try again later.")
                completionHandler(false)
            }
                
            else if let fetchedData = data {
                self.topicVersesArray.removeAll()
                self.subTopicsArray.removeAll()
                print("topicVersesArray count: \(self.topicVersesArray.count) , versesArray count: \(self.versesArray.count)")
                for subTopic in fetchedData.SubTopics {
                    self.subTopicsArray.append(subTopic)
                }
                print("This is subTopics Array:")
                print(self.subTopicsArray)
                
                for aya in fetchedData.Ayat {
                    self.topicVersesArray.append(aya)
                }
                print("This is topicVersesArray:")
                print(self.topicVersesArray.count)
                
                completionHandler(true)
            }
        })
    }
    
}


extension SearchQuranByTopicViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.selectedIndex == 0) {
            if(self.isTopicRequest == false) {
                return self.versesArray.count
            }
            else {
                return self.topicVersesArray.count
            }
        }
        else if(self.selectedIndex == 1) {
            return self.subTopicsArray.count
        }
        else {
            return self.relatedTopicsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(self.selectedIndex == 0){
            if(isTopicRequest == false) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchViewCell
            cell.searchSuraName.text =  versesArray[indexPath.row].SoraName
            cell.chapter.text = "الجزء رقم"
            cell.CN.text = versesArray[indexPath.row].ChapterNUM
                cell.searchVerse.text = 	"\(versesArray[indexPath.row].AyaText) {\(versesArray[indexPath.row].VerseNUM)}"
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchViewCell
                cell.searchSuraName.text =  topicVersesArray[indexPath.row].SoraName
                cell.chapter.text = "الجزء رقم"
                cell.CN.text = topicVersesArray[indexPath.row].ChapterNUM
                cell.searchVerse.text = "\(topicVersesArray[indexPath.row].AyaText) {\(topicVersesArray[indexPath.row].VerseNUM)}"
                
                return cell
                }
            
        }
        else if(self.selectedIndex == 1){
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
            cell.textLabel?.text = subTopicsArray[indexPath.row]
            return cell
//            cell?.textView.font = cell?.textView.font?.withSize(20)
//            cell?.configureCell(text: subTopicsArray[indexPath.row])
        }
        else{
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
            cell.textLabel?.text = relatedTopicsArray[indexPath.row]
            return cell
//            cell?.textView.font = cell?.textView.font?.withSize(20)
//            cell?.configureCell(text: relatedTopicsArray[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.selectedIndex == 1 || self.selectedIndex == 2) {
            performUIUpdatesOnMain {
                self.adjustMenuAndTable(isHidden: true)
                self.addActivityIndicator()
            }
            if(self.selectedIndex == 1) {
                self.selectedTopic = subTopicsArray[indexPath.row]
                print("Selected subtopic: \(subTopicsArray[indexPath.row])")
                userQuerySearchBar.text = subTopicsArray[indexPath.row]
                getAyatFromTopic(topic: subTopicsArray[indexPath.row], completionHandler: {(success) -> Void in
                    if success {
                        self.performUIUpdatesOnMain {
                            self.hideActivityIndicator()
                            self.adjustMenuAndTable(isHidden: false)
                            self.refreshContent()
                        }
                    }
                    else {
                        self.performUIUpdatesOnMain {
                            self.hideActivityIndicator()
                            self.showNoDataLabel()
                        }
                    }
                })
            }
            else {
                self.selectedTopic = relatedTopicsArray[indexPath.row]
                print("Selected related: \(relatedTopicsArray[indexPath.row])")
                userQuerySearchBar.text = relatedTopicsArray[indexPath.row]
                getAyatFromTopic(topic: relatedTopicsArray[indexPath.row], completionHandler: {(success) -> Void in
                    if success {
                        self.performUIUpdatesOnMain {
                            self.hideActivityIndicator()
                            self.adjustMenuAndTable(isHidden: false)
                            self.refreshContent()
                        }
                    }
                    else {
                        self.performUIUpdatesOnMain {
                            self.hideActivityIndicator()
                            self.showNoDataLabel()
                        }
                    }
                })
            }
        }
        else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        selectedIndex = 0
        selectedIndexPath = IndexPath(item: selectedIndex, section: 0)
        menuCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredVertically)
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(self.selectedIndex == 0) {
            return UITableViewAutomaticDimension
        }
        else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(self.selectedIndex == 0) {
            return self.selectedTopic
        }
        else {
            return ""
        }
    }
    
}


extension SearchQuranByTopicViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCollectionViewCell
        cell.setupCell(text: menuTitles[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / CGFloat(menuTitles.count), height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        refreshContent()
    }
    
}






