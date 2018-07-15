//
//  ViewController.swift
//  KakaoChat
//
//  Created by 김승진 on 2018. 7. 11..
//  Copyright © 2018년 김승진. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct UI {
        static let bottomIndictorSafeArea: CGFloat = 34
        static let KeyboardHeight_iPhoneX: CGFloat = 291
        static let textViewContentSizeMaxHeight: CGFloat = 100
        static let bubbleBottomMargin: CGFloat = 10
    }
    

    //MARK: - Property
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var inputTextView: UITextView!
    
    @IBOutlet weak var inputViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    
    private var datas: [String] = [
        "a;lksdjf;lkajsdfkljas;dlfkj;lakdjf;lkjasd;flkjkaldjflkajd;lfja;sdlfj;alsdjf;lkajds",
        "a;lksdjf;lkajsdfkljas;dlfkj;lakdjf;lkjasd;flkjj;lakdjf;lkjasd;flkjkaldjflkajd;lfja;sdlfj;alsdjf;lkajds",
        "a;lksdjf;lkajsdfkljas;dlfkj;lakdjf;lkjasd;flkjkaldjflkajd;lfja;sdlfj;alsdjf;lkajdsa;lksdjf;lkajsdfkljas;dlfkj;lakdjf;lkjasd;flkjkaldjflkajd;lfja;sd;dlfkj;lakdjf;lkjasd;flkjkaldjflkajd;lfja;sdlfj;alsdjf;lkajds",
        "a;lksdjf;lkajsdfkljas;dlfkj;lakdjf;lkjasd;flkjkaldjflkajd;lfja;sdlfj;alsdjf;lkajdsa;lksdjf;lkajsdfkljas;dlfkj;lakdjf;lkjasd;flkjkaldjflkajd;lfja;sdlfj;alsdjf;lkajdsa;lksdjf;lkajsdfkljas;dlfkj;lakdjf;lkjasd;flkjkaldjflkajd;lfja;sdlfj;alsdjf;lkajdsa;lksdjf;lkajsdfkljas;dlfkj;lakdjf;lkjasd;flkjkaldjflkajd;lfja;sdlfj;alsdjf;lkajds",
        "a;lksdjf;lkajsdfkljas;dlfkj;lakdjf;lkjasd;flkjkaldjflkajd;lfja;sdlfj;alsdjf;lkajdsa;lksdjf;lkajsdfkljas;dlfkj;lakdjf;lkjasd;flkjkaldjflkajd;lfja;sdlfj;alsdjf;lkajdsa;lksdjf;lkajsdfkljas;dlfkj;lakdjf;lkjasd;flkjkaldjflkajd;lfja;sdlfj;alsdjf;lkajdsa;lksdjf;lkajsdfkljas;dlfkj;lakdjf;lkjasd;flkjkaldjflkajd;lfja;sdlfj;alsdjf;lkajds"
    ]
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChatTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        lastScrollToRow()
    }
    
    //MARK: - Method
    
    private func setupChatTableView() {
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        
        //1번 : 처음에 chatTableView.rowHeight = UITableViewAutomaticDimension으로 잡아놓고
        //2번 : delegate에 estimatedHeightForRowAt에도 return UITableViewAutomaticDimension을 해놓는게 정해진 틀이라고 생각.
        self.chatTableView.rowHeight = UITableViewAutomaticDimension
        
        //Cell을 따로 만들었으면 등록을 하는 과정이 필요하다.
        self.chatTableView.register(UINib(nibName: "MyBubbleChatCell", bundle: Bundle.main), forCellReuseIdentifier: "MyBubbleChat")
        self.chatTableView.register(UINib(nibName: "YourBubbleChatCell", bundle: Bundle.main), forCellReuseIdentifier: "YourBubbleChat")
    }
    
    @objc private func keyboardWillShow(noti: Notification) {
        print(noti)
        
        //키보드의 높이를 가져오는 작업.
        let notiInfo = noti.userInfo! as Dictionary
        let keyboardFrame = notiInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let keyboardHeight = keyboardFrame.size.height
        
        print("iPhoneX",keyboardHeight)
        //FIXME: iPhoneX일때만 체크(파일 넣기 귀찮아서 그냥 키보드 높이로만 체크했음)
        if keyboardHeight == UI.KeyboardHeight_iPhoneX { // iPhoneX
            
            //키보드를 올리면서 제일 밑에 테이블 까지 올리기
            self.chatTableView.setContentOffset(CGPoint(x: 0, y: self.chatTableView.frame.height - keyboardHeight + UI.bottomIndictorSafeArea * 5), animated: true)
            self.inputViewBottomMargin.constant = keyboardHeight - UI.bottomIndictorSafeArea
            
        } else {
            self.chatTableView.setContentOffset(CGPoint(x: 0, y: self.chatTableView.frame.height - keyboardHeight - UI.bottomIndictorSafeArea - UI.bubbleBottomMargin), animated: true)
            self.inputViewBottomMargin.constant = keyboardHeight
        }
        
        UIView.animate(withDuration: notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(noti: Notification) {
        
        self.inputViewBottomMargin.constant = 0
        let notiInfo = noti.userInfo! as Dictionary
        UIView.animate(withDuration: notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func textInputDone(_ sender: UIButton) {
        guard self.inputTextView.hasText else { return }
        
        self.datas.append(self.inputTextView.text)
        chatTableView.reloadData()
        self.inputTextView.text = ""
        
        lastScrollToRow()
        textViewDidChange(inputTextView)
    }
    
    //테이블뷰의 마지막 스크롤로 이동. (원하는 row로 이동할 수 있다.)
    private func lastScrollToRow() {
        let lastIndexPath = IndexPath(row: datas.count - 1, section: 0)
        self.chatTableView.scrollToRow(at: lastIndexPath, at: UITableViewScrollPosition.bottom, animated: false)
        self.view.layoutIfNeeded()
    }
    
    private func currentTime() -> String{
        
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a-hh-mm"
        let stringDate = dateFormatter.string(from: currentTime)
        
        return stringDate
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


}

//MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defaultCell: UITableViewCell
        
        if indexPath.row % 2 == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyBubbleChat", for: indexPath) as! MyBubbleChatCell
            defaultCell = cell
            
            cell.bubbleText.text = datas[indexPath.row]
            cell.currentTime.text = currentTime()
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourBubbleChat", for: indexPath) as! YourBubbleChatCell
            
            defaultCell = cell
            
            cell.bubbleText.text = datas[indexPath.row]
            cell.currentTime.text = currentTime()
        }
        
        return defaultCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}

//MARK: - UITextViewDelegate

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        print(textView)
        
        let contentSizeHeight = textView.contentSize.height
        
        guard contentSizeHeight <= UI.textViewContentSizeMaxHeight else { return }
        textViewHeight.constant = textView.contentSize.height
    }
}
