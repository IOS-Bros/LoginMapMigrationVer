//
//  feddViewCell.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/04.
//

import UIKit

class feddViewCell: UITableViewCell {
    
    let pointColor : UIColor = UIColor.init(displayP3Red: 99/255, green: 197/255, blue: 148/255, alpha: 1)

    
    var hashTagList = [String]()
    
    var feedModel: FeedModel?
    var feedImageModel: FeedImageModel?
    
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var writerImage: UIImageView!
    @IBOutlet weak var writerName: UILabel!
    @IBOutlet weak var submitDate: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet var hashTagCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hashTagCollectionView.delegate = self
        hashTagCollectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        var justDebugStr = ""
        for str in hashTagList {
            justDebugStr += "[\(str)]"
        }
        print(justDebugStr)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.content.text = nil
        self.hashTagList.removeAll()
        self.content.translatesAutoresizingMaskIntoConstraints = false
        self.content.numberOfLines = 0
        self.updateLayout()
        self.hashTagCollectionView.reloadData()
    }
    
    func updateLayout(){
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

    
} // feedViewCell

extension feddViewCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hashTagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = hashTagCollectionView.dequeueReusableCell(withReuseIdentifier: "feedHashTagCell", for: indexPath) as! HashTagCollectionViewCell
        
        cell.backgroundColor = .lightGray
        cell.lblHashTag.numberOfLines = 1
        cell.lblHashTag.translatesAutoresizingMaskIntoConstraints = true
        cell.lblHashTag.text = "#\(hashTagList[indexPath.row])"
        cell.lblHashTag.numberOfLines = 1
        cell.lblHashTag.setTextView()
        cell.layer.cornerRadius = 4
        cell.layer.backgroundColor = pointColor.cgColor
        cell.lblHashTag.textColor = UIColor.white
        return cell
    }
}
