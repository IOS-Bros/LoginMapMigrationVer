//
//  CommentTableViewCell.swift
//  RndFinal
//
//  Created by SooHoon on 2021/08/11.
//

import UIKit

protocol CommentTableViewCellDelegate : class {
    func updateTextViewHeight(_ cell: CommentTableViewCell,_ textView:UITextView)
}

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCWriter: UILabel!
    @IBOutlet weak var tvComment: UITextView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    
    weak var delegate: CommentTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setTextView()
        tvComment.isUserInteractionEnabled = false
    }
    
    func setTextView(){
        tvComment.delegate = self
        // 텍스트 뷰 늘어나면 높이 높여서 한 칸 늘리기
        tvComment.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}//CommentTableViewCell

extension CommentTableViewCell: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = delegate {
            delegate.updateTextViewHeight(self, tvComment)
        }
    }
}

extension UITextView{
    func setTextView(){
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
    }
}

