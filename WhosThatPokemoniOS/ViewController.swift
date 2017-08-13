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
    
    @IBOutlet weak var monImageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var monName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getSettings()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getSettings()
    }
    
    func setupView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(switchImage))
        monImageView.isUserInteractionEnabled = true
        monImageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.monName.text = ""
        let pokemon = UIImage(named: "\(monIndex)")
        
        monImageView.image = pokemon
        if let settingsIcon = UIImage(named: "settings") {
            settingsButton.setBackgroundImage(settingsIcon.fillAlpha(fillColor: .black), for: .normal)
        }
        
        settingsButton.addTarget(self, action: #selector(segueToSettingView), for: .touchUpInside)
    }
    
    func selectPokemon() {
        var genRange: [(lower: Int, upper: Int)] = []
        
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
            let genIndex = Int(arc4random_uniform(UInt32(genRange.count)))
            let genLimits = genRange[genIndex]
            
            let upper = UInt32(genLimits.upper)
            let lower = UInt32(genLimits.lower)
            
            monIndex = Int(arc4random_uniform(upper - lower) + lower)
            
            if let newPokemon = UIImage(named: "\(monIndex)") {
                monImageView.image = newPokemon.fillAlpha(fillColor: .black)
            }
        }
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
            break
        case 1:
            UIView.transition(with: self.monImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.monImageView.image = UIImage(named: "\(self.monIndex)")
                self.monName.text = monData.getName(number: self.monIndex)
            }, completion: nil)
            break
        default:
            break
        }
    }
}
