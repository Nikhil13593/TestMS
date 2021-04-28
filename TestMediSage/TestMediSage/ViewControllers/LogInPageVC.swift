//
//  LogInPageVC.swift
//  TestMediSage
//
//  Created by NIKHIL KISHOR PATIL on 28/04/21.
//

import UIKit

class LogInPageVC: UIViewController {

    @IBOutlet weak var txtfieldUserName: UITextField!
    @IBOutlet weak var txtfieldPassword: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    //
    var emailId : String?
    var password : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.txtfieldUserName.delegate = self
        self.txtfieldPassword.delegate = self
        self.setupUIComponent()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setupUIComponent() {
        
        self.txtfieldUserName.textContentType = UITextContentType.emailAddress
        self.txtfieldPassword.textContentType = UITextContentType.password
        self.txtfieldUserName.tag = 0
        self.txtfieldPassword.tag = 1
        self.txtfieldUserName.layer.cornerRadius = 12
        self.txtfieldPassword.layer.cornerRadius = 12
        self.btnSubmit.layer.cornerRadius = self.btnSubmit.frame.height * 0.5
        self.btnSubmit.layer.masksToBounds = true
        self.txtfieldUserName.addDoneButtonOnKeyboard()
        self.txtfieldPassword.addDoneButtonOnKeyboard()
        self.btnSubmit.isEnabled = false
        self.btnSubmit.backgroundColor = UIColor.lightGray
    }
    
    //MARK: Button Actions
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        print("Button Working")
        if isValidEmail(emailId ?? "") == true && password?.count ?? 0 > 8 {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let TabBarViewController = storyBoard.instantiateViewController(identifier: "TabBarViewController") as? TabBarViewController
        if let TabBarPage = TabBarViewController {
//            TabBarPage.definesPresentationContext = true
//            TabBarPage.modalTransitionStyle = .crossDissolve
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(TabBarPage, animated: true)
            }
        }
    }
}
    
    //MARK: Alert Function
    func passwordAlert(){
        let alert = UIAlertController(title: "Password Error", message: "Password Length is Between 8 - 15", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OKAY", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Regular Experssion Func
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailPred.evaluate(with: email) == false {
            let alert = UIAlertController(title: "Username Error", message: "Please Enter Valid Username", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OKAY", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        return emailPred.evaluate(with: email)
    }
    
    //MARK: Condition Validation Func
    func validations() {
        
        if isValidEmail(emailId ?? "") == true && password?.count ?? 0 > 8 {
            self.btnSubmit.isEnabled = true
            self.btnSubmit.backgroundColor = UIColor.systemTeal
        } else if password?.count ?? 0 < 8 && password?.count ?? 0 > 15 {
            self.passwordAlert()
            self.btnSubmit.isEnabled = false
            self.btnSubmit.backgroundColor = UIColor.lightGray
        }else if isValidEmail(emailId ?? "") != true {
            self.btnSubmit.isEnabled = false
            self.btnSubmit.backgroundColor = UIColor.lightGray
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

}

extension LogInPageVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.btnSubmit.isEnabled = false
        self.btnSubmit.backgroundColor = UIColor.lightGray
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            isValidEmail(textField.text ?? "")
            emailId = textField.text ?? ""
            
        }else if textField.tag == 1{
            password = textField.text ?? ""
            
            if textField.text?.count ?? 0 < 8 || textField.text?.count ?? 0 > 15 {
                self.passwordAlert()
            }
        }
        self.validations()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 1{
            let maxLength = 15
            let currentString: NSString = textField.text! as NSString
            let newString: String =
                currentString.replacingCharacters(in: range, with: string) as String
            
            return newString.count <= maxLength
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UITextField {
    
    func addDoneButtonOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self, action: #selector(resignFirstResponder))
        keyboardToolbar.items = [flexibleSpace, doneButton]
        self.inputAccessoryView = keyboardToolbar
    }
}
