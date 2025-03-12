//
//  ViewController.swift
//  BMICalculatotUIKit
//
//  Created by Islam Rzayev on 05.02.25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var maleImageView: UIImageView!
    @IBOutlet weak var femaleImageView: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    
    var isMaleClicked: Bool = false
    var isFemaleClicked: Bool = false
    var sex: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.layer.cornerRadius = 25
        let tapGestureMale = UITapGestureRecognizer(target: self, action: #selector(maleImageTapped))
        let tapGestureFemale = UITapGestureRecognizer(target: self, action: #selector(femaleImageTapped))
        maleImageView.addGestureRecognizer(tapGestureMale)
        femaleImageView.addGestureRecognizer(tapGestureFemale)
        if isMaleClicked {
            sex = "Male"
        } else if isFemaleClicked {
            sex = "Female"
        }
        updateAlpha()
    }
    
    @objc func maleImageTapped() {
        isMaleClicked.toggle()
        isFemaleClicked = false
        sex = "Male"
        updateAlpha()
    }
    @objc func femaleImageTapped() {
        isFemaleClicked.toggle()
        isMaleClicked = false
        sex = "Female"
        updateAlpha()
       
    }
    func updateAlpha() {
        maleImageView.alpha = isMaleClicked ? 1.0 : 0.5
        femaleImageView.alpha = isFemaleClicked ? 1.0 : 0.5
        continueButton.alpha = isMaleClicked || isFemaleClicked ? 1.0 : 0.5
        
        if isMaleClicked || isFemaleClicked {
            continueButton.isEnabled = true
        }else{
            continueButton.isEnabled = false
        }
    }
    @IBAction func continueClicked(_ sender: Any) {
        if isMaleClicked {
            sex = "Male"
        } else if isFemaleClicked {
            sex = "Female"
        }
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ModifyViewController") as? ModifyViewController{
            vc.sex = sex
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
}


