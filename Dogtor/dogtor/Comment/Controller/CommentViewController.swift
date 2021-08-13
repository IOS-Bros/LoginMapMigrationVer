//
//  CommentViewController.swift
//  RndFinal
//
//  Created by SooHoon on 2021/08/11.
//

import UIKit
import Kingfisher

class CommentViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tbComment: UITableView!
    @IBOutlet weak var tvAddComment: UITextView!
    @IBOutlet weak var insertView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var commentAddButton: UIButton!
    
    var commentArray: NSMutableArray = NSMutableArray()
    var commentImageArray: NSMutableArray = NSMutableArray()
    
    var cNo = 0
    var cSubmitDate = ""
    var cWriter = Share.userNickName
    var cNickName = ""
    var cContent = ""
    var fNo = 0
    
    var commentSelectWriterImage = CommentSelectWriterImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        receiveFNo(fNo: fNo)
        print(fNo)
        // cell 불러오기
        let commentSelectModel = CommentSelectModel()
        commentSelectModel.delegate = self
        commentSelectModel.getComment(fNo: fNo)
        print("Data Selcted")
    
        delayTime()
        scrollView.isScrollEnabled = false
        textViewProperty()
        // Dynamic Heigh of UIVIew
        insertView.setView()
//        insertView.resignFirstResponder()
        
        cellPropertySetting()   // cell dynamic Height & others property
                     
        print("~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ")
        
        //Keyboard Handling
            // keyboardShow
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            // keyboarHide
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    } // ViewDidLoad

    
    override func viewWillAppear(_ animated: Bool) {

//        let commentSelectModel = CommentSelectModel()
//        commentSelectModel.delegate = self
//        commentSelectModel.getComment(fNo: fNo)
//        print("Data Reload")
    }
    
    func receiveFNo(fNo: Int){
        self.fNo = fNo
    }
    
    // textView Design
    func textViewProperty(){
        tvAddComment.text = ""
        tvAddComment.layer.borderWidth = 0.7
        tvAddComment.layer.borderColor = UIColor.gray.cgColor
        tvAddComment.layer.cornerRadius = 20
        tvAddComment.textContainerInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        
        // textView Delegate >> Dynamic Height
        tvAddComment.resignFirstResponder()
        tvAddComment.delegate = self
        tvAddComment.setInsertTextView()
        tvAddComment.returnKeyType = .continue
    }
    
    
    // 빈값 입력하면 버튼 비활성화
    func addNilCheck(){
        
        if tvAddComment.text.isEmpty {
            commentAddButton.isEnabled = false
            print("Nil is detected")
        } else {
            commentAddButton.isEnabled = true
        }
    }
    
    // TableViewCell 속성 세팅
    func cellPropertySetting(){
        // tableViwe Delegate
        tbComment.delegate = self
        tbComment.dataSource = self
        tbComment.rowHeight = UITableView.automaticDimension
        tbComment.estimatedRowHeight = 500
        tbComment.separatorStyle = .none
        tbComment.translatesAutoresizingMaskIntoConstraints = true
    }
    
    // 시작하고 2초후에 댓글 입력 텍스트 뷰 활성화
    func delayTime(){
        let time = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: time, execute: delayTextview)
    }
    
    func delayTextview(){
        tvAddComment.isUserInteractionEnabled = true
    }
    
    // NotificationCenter Selector func ***************
    @objc func keyboardWillShow(notification: NSNotification) {
       
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
        
        if let newFrame = (notification.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsets( top: newFrame.height, left: 0, bottom: 0, right: 0 )
                    tbComment.scrollIndicatorInsets = insets
                    tbComment.contentInset = insets
                }
        // move the root view up by the distance of keyboard height
            self.view.frame.origin.y = 0 - keyboardSize.height // 키보드 높이만큼 뷰를 위로 올린다.
            scrollView.frame.size.height = 780
            tbComment.frame.size.height = 727
            scrollView.isScrollEnabled = false
        tvAddComment.frame.size.height = 70
    }
      
    @objc func keyboardWillHide(notification: NSNotification) {
          // move back the root view origin to zero
            self.view.frame.origin.y = 0
            tbComment.frame.size.height = 670
        tvAddComment.frame.size.height = 35
            
            if let newFrame = (notification.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
                let insets = UIEdgeInsets( top: 0, left: 0, bottom: 0, right: 0 )
                    tbComment.scrollIndicatorInsets = insets
                    tbComment.contentInset = insets
            }
    }
    
    // 텍스트 뷰 줄 늘어날때마다 뷰와 텍스트 뷰 높이 키우기
    func textViewDidChange(_ textView: UITextView) {

        if tvAddComment.frame.size.height < 60 {

        let maximumWidth: CGFloat = 331 // Change as appropriate for your use.
        let maximunheight: CGFloat = 105
        let newSize = textView.sizeThatFits(CGSize(width: maximumWidth, height: .greatestFiniteMagnitude ))

                textView.frame.size = newSize
                insertView.frame.size = newSize
        var newFrame = textView.frame

            newFrame.size = CGSize(width: max(newSize.width, maximumWidth), height: newSize.height)
                textView.frame = newFrame
                insertView.frame = newFrame

        } else {
            
        }
    }

    
    @IBAction func btnAddComment(_ sender: UIButton) {
        
        addNilCheck()

        cContent = tvAddComment.text
        
        print(" count 1 : " , commentArray.count)
        let insertModel = CommentInsertModel()
        insertModel.delegate = self
        insertModel.insertGetComment(cWriter: cWriter, cContent: cContent, fNo: fNo)
        print("insert End")
        
        tvAddComment.text = ""
    }
    
    func scrollToBottom(){
    
           DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.commentArray.count - 1, section: 0)
            if self.commentArray.count == 0 {
                
            }else{
               self.tbComment.scrollToRow(at: indexPath, at: .bottom, animated: true)
            print("Scroll Down")
            }
        }
    }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

} // ViewCOntroller

    
//============================================


extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    // cell 설정
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        
        print("#")
        cell.delegate = tbComment as? CommentTableViewCellDelegate
        
        let comment: CommentDBModel = commentArray[indexPath.row] as! CommentDBModel
        
        
        // 불러온 댓글에 있는 각자 이름
        cell.lblCWriter.text = comment.cWriter
        cell.tvComment.text = comment.cContent!
        
        cNickName = cell.lblCWriter.text!
        print("Writer : \(cell.lblCWriter.text!) , Cotent: \(cell.tvComment.text!) ")
        
        //선택시 회색배경처리되는거 제거
        cell.selectionStyle = .none
        
        loadCommentWriterImage(cell: cell)
        return cell
    }
        
//        let commentImage : CommentImageModel = commentImageArray[indexPath.row] as! CommentImageModel
        
//        cell.imgProfile.image = UIImage
        
        //작성자 이미지 검색
//        loadCommentWriterImage(item: commentImage, cell: cell)
        
       
        
        // 킹피셔 라이브러리
        func loadCommentWriterImage(cell: CommentTableViewCell){
            DispatchQueue.global().async {
//                self.commentSelectWriterImage.requestCommentWirterImage(nickName: self.cNickName, completion: {data in
//                    guard let imageName = data else {
//                        return
//                    }
                
                let commentImageSelct = CommentImageSelectModel()
                commentImageSelct.delegate = self
                commentImageSelct.getCommentImage(cNickName: cell.lblCWriter.text! ,complation: {action in
                    print("# # # # # # # # # # # ", action!)
                    guard let url = URL(string: action!) else { return }
                    
                    DispatchQueue.main.async {
                        cell.imgProfile.kf.setImage(with: url)
                        cell.imgProfile.layer.cornerRadius = 7.5
                    }
                })
            }
        
    };

    // 스와이프해서 셀 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let comment : CommentDBModel = commentArray[indexPath.row] as! CommentDBModel
        
        if editingStyle == .delete {
            
            // 삭제에 사용할 키 값 불러오기
            let cNo = comment.cNo!
            print("cNo :", cNo)
            let deleteModel = DeleteModel()
            let result = deleteModel.DeleteItems(cNo: cNo)
            print("---->", result)
            
                if result == true{
                    let resultAlert = UIAlertController(title: "완료", message: "삭제가 완료됐습니다", preferredStyle: .alert)
                    let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
                        self.commentArray.removeObject(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    })
                    
                    resultAlert.addAction(onAction)
                    present(resultAlert, animated: true, completion: nil)
                    
                }else{
                    let resultAlert = UIAlertController(title: "실패", message: "에러가 발생했습니다", preferredStyle: .alert)
                    let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                    resultAlert.addAction(onAction)
                    present(resultAlert, animated: true, completion: nil)
                }
            }else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}
// UITableView extension


extension UITextView {
    func setInsertTextView(){
        self.translatesAutoresizingMaskIntoConstraints = true
        self.isScrollEnabled = true
    }
}

extension UIView{
    func setView(){
        let newView = UIView()
        self.addSubview(newView)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.sizeToFit()
    }
}


extension CommentViewController : CommentSelectProtocol{
    func commentDownload(comment: NSArray) {
        commentArray = comment as! NSMutableArray
        self.tbComment.reloadData()
    }
} // SelectProtocol

extension CommentViewController: CommenteSelectModelProtocol{
    func CommentImageDownloaded(items: NSMutableArray) {
        commentImageArray = items
//        self.tbComment.reloadData()
    }
    
    
}

extension CommentViewController : CommentInsertProtocol{
    func insertDownload(comment: NSArray) {
        commentArray = comment as! NSMutableArray
        self.tbComment.reloadData()
        scrollToBottom()

    }
} // InsertProtocol

