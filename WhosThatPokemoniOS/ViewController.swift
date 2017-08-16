//
//  ViewController.swift
//  WhosThatPokemoniOS
//
//  Created by Dylan Conway on 09/08/2017.
//  Copyright © 2017 Dylan Conway. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var index = -1
    var monIndex = 1
    
    var settings = [SettingKey]()
    
    var correctButton: ChoiceButton!
    
    var genRange: [(lower: Int, upper: Int)] = []
    
    
    @IBOutlet weak var monImageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var monName: UILabel!
    
    @IBOutlet var choiceButtons: [ChoiceButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
    }
    
    func setupView() {
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(switchImage))
//        monImageView.isUserInteractionEnabled = true
//        monImageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.monName.text = ""
        let pokemon = UIImage(named: String(format: "%03d", monIndex))
        
        monImageView.image = pokemon
        if let settingsIcon = UIImage(named: "settings") {
            settingsButton.setBackgroundImage(settingsIcon.fillAlpha(fillColor: .black), for: .normal)
        }
        
        settingsButton.addTarget(self, action: #selector(segueToSettingView), for: .touchUpInside)
        
        getSettings()
        
        switchImage()
        
        for button in choiceButtons {
            button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        }
    }
    
    func selectPokemon() {
        genRange = []
        
        for setting in self.settings {
            switch setting {
            case .genI:
                genRange.append((1, 151))
                break
            case .genII:
                genRange.append((152, 251))
                break
            case .genIII:
                genRange.append((252, 386))
                break
            case .genIV:
                genRange.append((387, 493))
                break
            case .genV:
                genRange.append((494, 649))
                break
            case .genVI:
                genRange.append((650, 721))
                break
            case .genVII:
                genRange.append((727, 802))
                break
            default:
                break
            }
        }
        
        if !genRange.isEmpty {
            monIndex = randomWithinGenRange()
            
            if let newPokemon = UIImage(named: String(format: "%03d", monIndex)) {
                monImageView.image = newPokemon.fillAlpha(fillColor: .black)
            }
            
            setupButtons()
        }
    }
    
    func randomWithinGenRange() -> Int {
        if !genRange.isEmpty {
            let genIndex = Int(arc4random_uniform(UInt32(genRange.count)))
            let genLimits = genRange[genIndex]
            
            let upper = UInt32(genLimits.upper)
            let lower = UInt32(genLimits.lower)
            
            return Int(arc4random_uniform(upper - lower) + lower)
        }
        
        return 0
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

// MARK: Navigation
extension ViewController {
    
    func segueToSettingView() {
        let settingVC = SettingsViewController(nibName: String(describing: SettingsViewController.self), bundle: nil)
        self.present(settingVC, animated: true, completion: nil)
        
    }
}

// MARK: Settings
extension ViewController {
    
    func getSettings() {
        self.settings = []
        for key in iterateEnum(SettingKey.self) {
            if UserDefaults.standard.bool(forKey: key.rawValue) {
                self.settings.append(key)
            }
        }
    }
}


// MARK: Images
extension ViewController {
    
    func switchImage() {
        index = (index+1) % 2
        
        switch index {
        case 0:
            self.selectPokemon()
            self.monName.text = ""
            resetButtons()
            break
        case 1:
            for button in self.choiceButtons {
                button.isUserInteractionEnabled = false
            }
            
            UIView.transition(with: self.monImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.monImageView.image = UIImage(named: String(format: "%03d", self.monIndex))
                self.monName.text = monData.getName(number: self.monIndex)
            }) { _ in
                let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    UIView.transition(with: self.monImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.switchImage()
                    }) { _ in
                        for button in self.choiceButtons {
                            button.isUserInteractionEnabled = true
                        }
                    }
                }
            }
            break
        default:
            break
        }
    }
}


// MARK: Button Logic
extension ViewController {
    
    func resetButtons() {
        for button in self.choiceButtons {
            button.reset()
        }
    }
    
    func setupButtons() {
        if !choiceButtons.isEmpty {
            let index = self.choiceButtons.index(self.choiceButtons.startIndex, offsetBy: Int(arc4random_uniform(UInt32(self.choiceButtons.count-1))))
            correctButton = self.choiceButtons[index]//[Int(arc4random_uniform(self.choiceButtons.count))]
            
            for button in self.choiceButtons {
                if button == correctButton {
                    button.setTitle(monData.getName(number: self.monIndex), for: .normal)
                } else {
                    let name = monData.getName(number: randomWithinGenRange())
                    button.setTitle(name, for: .normal)
                }
            }
        }
    }
    
    func buttonPressed(sender: UIButton) {
        if sender == correctButton {
            sender.layer.backgroundColor = UIColor.green.cgColor
        } else {
            sender.layer.backgroundColor = UIColor.red.cgColor
        }
        
        switchImage()
    }
}
