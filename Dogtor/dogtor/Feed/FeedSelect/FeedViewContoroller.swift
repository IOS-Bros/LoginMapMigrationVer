//  FeedViewContorollerViewController.swift
//  dogtor
//Command CompileSwiftSources failed with a nonzero exit code
//  Created by 윤재필 on 2021/08/04.

import UIKit
import Kingfisher

class FeedViewContoroller: UIViewController {

    @IBOutlet var feedListTableView: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnSearchIcon: UIButton!
    
    var feedItem: NSMutableArray = NSMutableArray()
    var feedImageItem: NSMutableArray = NSMutableArray()
    
    
    //####################################
    let loginedUserid = Share.userNickName
    //####################################
    
    //cell생성시 호출하면 셀 개수만큼 인스턴스가 생성되므로 미리 선언
    let feedWriterDataSelectModel = FeedWriterDataSelectModel()
    
    let pointColor : UIColor = UIColor.init(displayP3Red: 99/255, green: 197/255, blue: 148/255, alpha: 1)
    
    // MARK: - function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //이후 수정
        feedListTableView.delegate = self
        feedListTableView.dataSource = self
        itemDesignSet()
        
        tableDataLoad(nil)
        initRefresh()
    } //viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        //[수정요함]이거 빼고 글 작성했으면 navigation으로 갱신하기
        tableDataLoad(nil)
    } //viewWillAppear
    
    func itemDesignSet(){
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 99/255, green: 197/255, blue: 148/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        btnSearchIcon.layer.cornerRadius = 4
        tfSearch.layer.borderWidth = 1
        tfSearch.layer.borderColor = pointColor.cgColor
        tfSearch.layer.cornerRadius = 8.0
    }
    
    func tableDataLoad(_ condition: String?){
        let feedSelectAllModel = FeedSelectAllModel()
        feedSelectAllModel.delegate = self
        feedItem.removeAllObjects()
        feedImageItem.removeAllObjects()
        feedSelectAllModel.feedDownloaded(condition)
    }
    
    //아래로 당겨서 리프레시
    func initRefresh(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "새로고침")
        
        if #available(iOS 10.0, *){
            feedListTableView.refreshControl = refresh
        } else {
            feedListTableView.addSubview(refresh)
        }
    }
    @objc func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        tableDataLoad(nil)
        feedListTableView.reloadData()
    }
    
    //검색버튼 액션
    @IBAction func btnSearch(_ sender: UIButton) {
        //비었을시 비활성화
        if tfSearch.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            tableDataLoad(nil)
        }
        let inputedSearchStr = tfSearch.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        tableDataLoad(inputedSearchStr)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view coself.feedWriterDataSelectModel.requestWirterImage(item)ntroller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "modifyFeedSegue"{
            let cell = sender as! feddViewCell // 몇번째 cell 인지
            let detailView = segue.destination as! FeedAddViewController
            guard let feedImageModel = cell.feedImageModel else {
                return
            }
            detailView.recieveItems(feedModel: cell.feedModel!, feedImageModel: feedImageModel)
            print("[feedModel]")
            cell.feedModel?.printAllFromSelectModel()
            print("---------------------------")
            print("[feedImageModel]")
            cell.feedImageModel?.printAll()
        }
        if segue.identifier == "commentSegue" {
            let button = sender as! UIButton
            let contentView = button.superview
            let cell = contentView?.superview as! feddViewCell
            let fNo = cell.feedModel?.fNo
            let goComment = segue.destination as! CommentViewController
            goComment.receiveFNo(fNo: fNo!)
            print("@ @ @ @ @ @ @ @ @ @ @ @ \n \(fNo!)")
            
        }
    }
    
}

// MARK: - Extiension
extension FeedViewContoroller: FeedSelectAllModelProtocol{
    func feedDownloaded(items: NSMutableArray) {
        feedItem = items
        
        //데이터를 로드한 후 이미지를 불러온다
        let feedImageSeelectAllModel = FeedImageSelectAllModel()
        feedImageSeelectAllModel.delegate = self
        feedImageSeelectAllModel.feedImageDownloaded()
        
    }
}
extension FeedViewContoroller: FeedImageSelectAllModelProtocol{
    func feedImageDownloaded(items: NSMutableArray) {
        feedImageItem = items
        //이미지 로드가 끝난 후 테이블 리로드
        self.feedListTableView.reloadData()
    }
}

// MARK: - Table view data source

extension FeedViewContoroller: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItem.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedListTableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! feddViewCell
        
        let item: FeedModel = feedItem[indexPath.row] as! FeedModel
        cell.feedModel = item
        cell.writerName.text = item.fWriter
        cell.submitDate.text = item.fSubmitDate
        cell.content.text = item.fContent
        cell.content.numberOfLines = 0
        cell.content.setTextView()
        
        let hashTagStrs = item.fHashTag
        cell.hashTagList.removeAll()
        if hashTagStrs == "none" {
            
        } else {
            let splitedHashTags = hashTagStrs.split(separator: " ")
            for hashTag in splitedHashTags {
                cell.hashTagList.append(String(hashTag))
            }
            cell.hashTagCollectionView.reloadData()
        }
        
        //피드이미지 검색
        loadImage(item: item, cell: cell)
        print("\(indexPath.row)번째 셀의 데이터")
        item.printAllFromSelectModel()
        
        //작성자 이미지 검색
        loadWriterImage(item: item, cell: cell)
        
        //선택시 회색배경처리되는거 제거
        cell.selectionStyle = .none
        
        return cell
    }
    
    func loadWriterImage(item: FeedModel, cell: feddViewCell){
        DispatchQueue.global().async {
            self.feedWriterDataSelectModel.requestWirterImage(nickName: item.fWriter, completion: {data in
                guard let imageName = data else {
                    return
                }
                
                var imagePath: String
                if imageName.contains("http") {
                    imagePath = imageName
                } else {
                    imagePath = Common.writerImagePath + imageName
                }
                print("writer image full path : \(imagePath)")
                guard let url = URL(string: imagePath) else { return }
        
                DispatchQueue.main.async {
                    cell.writerImage.kf.setImage(with: url)
                    cell.writerImage.layer.cornerRadius = 7.5
                }
            })
        }
    }
    
    func loadImage(item: FeedModel, cell: feddViewCell) {
        DispatchQueue.global().async {
            var imagePath: String?
            
            for imageDTO in self.feedImageItem {
                let dto = imageDTO as! FeedImageModel
                if item.fNo == dto.fNo {
                    imagePath = dto.imagePath
                    cell.feedImageModel = dto
                }
            }
            guard let _ = imagePath else { return }
            guard let url = URL(string: imagePath!) else { return }
            DispatchQueue.main.async {
                cell.feedImage.kf.setImage(with: url)
            }
        }
    }
    
}//FeedViewContoroller: UITableViewDelegate, UITableViewDataSource

extension UILabel {
    func setTextView() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
    }
}
