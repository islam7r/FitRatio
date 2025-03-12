//
//  ResultViewController.swift
//  BMICalculatotUIKit
//
//  Created by Islam Rzayev on 05.02.25.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var r1: UIView!
    @IBOutlet weak var bmiValue: UILabel!
    @IBOutlet weak var weightValue: UILabel!
    @IBOutlet weak var heightValue: UILabel!
    @IBOutlet weak var ageValue: UILabel!
    @IBOutlet weak var sexValue: UILabel!
    
    @IBOutlet weak var underWeightView: UIView!
    @IBOutlet weak var normalWeightView: UIView!
    @IBOutlet weak var overweightWeightView: UIView!
    @IBOutlet weak var obeseWeightView: UIView!
    
    @IBOutlet weak var healthyWeightRangeLabel: UILabel!
    
    var closeClicked: (() -> Void)?
    
    
    var weight: Double? = nil
    var age: Int? = nil
    var height: Double? = nil
    var sex: String? = nil
    var bmi: Double? = nil
    
    enum Result{
        case underweight
        case normal
        case overweight
        case obese
         
        var backgroundColor: UIColor {
            switch self {
            case .underweight:
                return UIColor(named: "lowResultColor")?.withAlphaComponent(0.4) ?? .cyan.withAlphaComponent(0.4)
            case .normal:
                return UIColor(named: "goodResultColor")?.withAlphaComponent(0.4) ?? .systemGreen.withAlphaComponent(0.4)
            case .overweight:
                return UIColor(named: "highResultColor")?.withAlphaComponent(0.4) ?? .systemYellow.withAlphaComponent(0.4)
            case .obese:
                return UIColor(named: "obeseResultColor")?.withAlphaComponent(0.4) ?? .systemRed.withAlphaComponent(0.4)
            }
        }
        var textColor: UIColor {
            switch self{
            case .underweight:
                return UIColor(named: "lowResultColor") ?? .cyan
            case .normal:
                return UIColor(named: "goodResultColor") ?? .systemGreen
            case .overweight:
                return UIColor(named: "highResultColor") ?? .systemYellow
            case .obese:
                return UIColor(named: "obeseResultColor") ?? .systemRed
            }
        }
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        r1.layer.cornerRadius = 30
        r1.layer.shadowColor = UIColor.black.cgColor
        r1.layer.shadowOpacity = 0.5
        r1.layer.shadowOffset = CGSize(width: 5, height: 5)
        r1.layer.shadowRadius = 10
        
        NSLayoutConstraint.activate([
            separatorView.widthAnchor.constraint(equalToConstant: mainStackView.frame.width),
        ])
    }
    func bmiCategory(for bmi: Double){
        if bmi < 18.5 {
            r1.backgroundColor = Result.underweight.backgroundColor
            
            bmiValue.textColor = Result.underweight.textColor
            weightValue.textColor = Result.underweight.textColor
            heightValue.textColor = Result.underweight.textColor
            ageValue.textColor = Result.underweight.textColor
            sexValue.textColor = Result.underweight.textColor
            healthyWeightRangeLabel.textColor = Result.underweight.textColor
            underWeightView.alpha = 1
            
        } else if bmi >= 18.5 && bmi < 25 {
            r1.backgroundColor = Result.normal.backgroundColor
            bmiValue.textColor = Result.normal.textColor
            weightValue.textColor = Result.normal.textColor
            heightValue.textColor = Result.normal.textColor
            ageValue.textColor = Result.normal.textColor
            sexValue.textColor = Result.normal.textColor
            healthyWeightRangeLabel.textColor = Result.normal.textColor
            normalWeightView.alpha = 1
        } else if bmi >= 25 && bmi < 30 {
            r1.backgroundColor = Result.overweight.backgroundColor
            bmiValue.textColor = Result.overweight.textColor
            weightValue.textColor = Result.overweight.textColor
            heightValue.textColor = Result.overweight.textColor
            ageValue.textColor = Result.overweight.textColor
            sexValue.textColor = Result.overweight.textColor
            healthyWeightRangeLabel.textColor = Result.overweight.textColor
            overweightWeightView.alpha = 1
        } else {
            r1.backgroundColor = Result.obese.backgroundColor
            bmiValue.textColor = Result.obese.textColor
            weightValue.textColor = Result.obese.textColor
            heightValue.textColor = Result.obese.textColor
            ageValue.textColor = Result.obese.textColor
            sexValue.textColor = Result.obese.textColor
            healthyWeightRangeLabel.textColor = Result.obese.textColor
            obeseWeightView.alpha = 1
        }
    }
    func updateUI(){
        weightValue.text = "\(weight ?? 0) kg"
        heightValue.text = "\(String(format: "%.1f", height ?? 0)) cm"
        ageValue.text = "\(age ?? 0)"
        sexValue.text = sex
        bmiValue.text = "\(bmi ?? 0)"
    }
    @IBAction func closeClicked(_ sender: Any) {
        closeClicked?()
        self.view.removeFromSuperview() 
        self.removeFromParent()
    }
    

}
