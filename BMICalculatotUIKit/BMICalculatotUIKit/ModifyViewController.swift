//
//  ModifyViewController.swift
//  BMICalculatotUIKit
//
//  Created by Islam Rzayev on 05.02.25.
//

import UIKit

class ModifyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var r1: UIView!
    @IBOutlet weak var r2: UIView!
    @IBOutlet weak var r3: UIView!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var weightIncrementButton: UIButton!
    @IBOutlet weak var weightDecrementButton: UIButton!
    @IBOutlet weak var ageIncrementButton: UIButton!
    @IBOutlet weak var ageDecrementButton: UIButton!
    
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var calculateButton: UIButton!
    
    var isCalculated: Bool = false
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    var healthyRange: String = ""
    
    var weight: Double = 60
    var age: Int = 20
    var height: Double = 150
    var sex: String = ""
    var bmi: Double = 0
    
    var finalAge: String = ""
    var finalWeight: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        r1.layer.cornerRadius = 30
        r2.layer.cornerRadius = 30
        r3.layer.cornerRadius = 30
        calculateButton.layer.cornerRadius = 25
        
        
        weightLabel.text = String(format: "%.0f", weight)
        ageLabel.text = "\(age)"
        heightLabel.text = "\(height)"
        heightSlider.minimumValue = 50
        heightSlider.maximumValue = 250
        heightSlider.value = 150
        
        updateValues()
        calculateBMI()
       
        blurView.frame = view.bounds
        
        addLongPressGesture(to: weightIncrementButton, action: #selector(weightIncrementLongPress))
        addLongPressGesture(to: weightDecrementButton, action: #selector(weightDecrementLongPress))
        addLongPressGesture(to: ageIncrementButton, action: #selector(ageIncrementLongPress))
        addLongPressGesture(to: ageDecrementButton, action: #selector(ageDecrementLongPress))
        
        setUpBlurView()
        updateResultView()

        
        
        
   
        
    }
    func updateResultView() {
        if let resultVC = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
            resultVC.loadViewIfNeeded()
            
            
            blurView.contentView.subviews.forEach{
                $0.removeFromSuperview()
            }
            blurView.contentView.addSubview(resultVC.r1)
            resultVC.r1.translatesAutoresizingMaskIntoConstraints = false
            
            resultVC.age = age
            resultVC.weight = weight
            resultVC.height = height
            resultVC.sex = sex
            resultVC.bmi = bmi
            
            resultVC.underWeightView.alpha = 0
            resultVC.normalWeightView.alpha = 0
            resultVC.overweightWeightView.alpha = 0
            resultVC.obeseWeightView.alpha = 0
        
            
            resultVC.updateUI()
            resultVC.bmiCategory(for: bmi)
            
            resultVC.healthyWeightRangeLabel.text = self.healthyWeightRange(for: height)
            
            resultVC.closeClicked = {
                DispatchQueue.main.async {
                    self.isCalculated.toggle()
                    self.setUpBlurView()
                    resultVC.view.removeFromSuperview()
                    resultVC.removeFromParent()
                    
                    resultVC.weight = nil
                    resultVC.age = nil
                    resultVC.height = nil
                    resultVC.sex = nil
                    resultVC.bmi = nil
                    self.blurView.contentView.subviews.forEach{
                        $0.removeFromSuperview()
                    }
                }
            }
            NSLayoutConstraint.activate([
                resultVC.r1.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor),
                resultVC.r1.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 20),
                resultVC.r1.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -20),
            ])
            blurView.contentView.layoutIfNeeded()
            
            addChild(resultVC)
        }
    }
    func addLongPressGesture(to button: UIButton, action: Selector) {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: action)
        longPressGesture.minimumPressDuration = 0.3 
        button.addGestureRecognizer(longPressGesture)
    }

    @objc func weightIncrementLongPress(_ gesture: UILongPressGestureRecognizer) {
        handleLongPress(gesture, incrementAction: { self.weight += 1 })
        updateValues()
        
    }

    @objc func weightDecrementLongPress(_ gesture: UILongPressGestureRecognizer) {
        handleLongPress(gesture, incrementAction: {
            if self.weight > 0 {
                self.weight -= 1
            }
        })
        updateValues()
    }
    
    @objc func ageIncrementLongPress(_ gesture: UILongPressGestureRecognizer) {
        handleLongPress(gesture, incrementAction: { self.age += 1 })
        updateValues()
    }

    @objc func ageDecrementLongPress(_ gesture: UILongPressGestureRecognizer) {
        handleLongPress(gesture, incrementAction: {
            if self.age > 0 {
                self.age -= 1
            }
        })
        updateValues()
    }

    func handleLongPress(_ gesture: UILongPressGestureRecognizer, incrementAction: @escaping () -> Void) {
        switch gesture.state {
        case .began:
            startRepeatingAction(incrementAction)
        case .ended, .cancelled:
            stopRepeatingAction()
        default:
            break
        }
    }

    var timer: Timer?

    func startRepeatingAction(_ action: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            action()
            self.updateValues()
        }
    }

    func stopRepeatingAction() {
        timer?.invalidate()
        timer = nil
    }
    
    func healthyWeightRange(for height: Double) -> String {
        let heightInMeters = height / 100
        let minWeight = 18.5 * pow(heightInMeters, 2)
        let maxWeight = 24.9 * pow(heightInMeters, 2)
        
        
        return ("\(String(format: "%.1f", minWeight)) kg - \(String(format: "%.1f", maxWeight)) kg")
    }
    func setUpBlurView() {
        if isCalculated {
            if blurView.superview == nil {
                blurView.alpha = 0
                UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.view.addSubview(self.blurView)
                })
                UIView.animate(withDuration: 0.5, animations: {
                    self.blurView.alpha = 1
                })
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.blurView.alpha = 0
            })
            self.blurView.removeFromSuperview()
            
        }
    }
   

    
    @IBAction func weightMinusClicked(_ sender: Any) {
        guard weight > 0 else { return }
        weight -= 1
        updateValues()
    }
    @IBAction func weightPlusClicked(_ sender: Any) {
        weight += 1
        updateValues()
    }
    @IBAction func ageMinusClicked(_ sender: Any) {
        guard age > 0 else{return}
        age -= 1
        updateValues()
    }
    @IBAction func agePlusClicked(_ sender: Any) {
        age += 1
        updateValues()
    }
    @IBAction func heightSlider(_ sender: UISlider) {
        height = Double(String(format: "%.1f", sender.value)) ?? 0.0
        updateValues()
    }
    
    func updateValues(){
        weightLabel.text = String(format: "%.0f", weight)
        ageLabel.text = "\(age)"
        heightLabel.text = "\(height)"
        self.finalWeight = String(format: "%.0f", weight)
        self.finalAge = String(format: "%.0f", age)
        
    }
    
    @IBAction func calculateClicked(_ sender: Any) {
        calculateBMI()
        isCalculated.toggle()
        updateResultView()
        setUpBlurView()
        updateValues()
        
    }
    
    func calculateBMI(){
        let heightM = height / 100
        bmi = Double(String(format: "%.1f" , weight / pow(heightM, 2))) ?? 0.0
    }

}
