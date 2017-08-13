//
//  SettingsViewController.swift
//  WhosThatPokemoniOS
//
//  Created by Dylan Conway on 09/08/2017.
//  Copyright © 2017 Dylan Conway. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsTable: UITableView!
    
    var settingsData = [String:[SettingTableField]]()
    
    override func viewDidLoad() {
        
        self.settingsTable.delegate = self
        self.settingsTable.dataSource = self
        
        var generations: [SettingTableField] = []
        generations.append(SettingTableField(withTitle: "Generation I",     withValue: .genI,   cellType: .toggle))
        generations.append(SettingTableField(withTitle: "Generation II",    withValue: .genII,  cellType: .toggle))
        generations.append(SettingTableField(withTitle: "Generation III",   withValue: .genIII, cellType: .toggle))
        generations.append(SettingTableField(withTitle: "Generation IV",    withValue: .genIV,  cellType: .toggle))
        generations.append(SettingTableField(withTitle: "Generation V",     withValue: .genV,   cellType: .toggle))
        //generations.append(SettingTableField(withTitle: "Generation VI",    withValue: .genVI,  cellType: .toggle))
        //generations.append(SettingTableField(withTitle: "Generation VII",   withValue: .genVII, cellType: .toggle))
        
        settingsData["Generations"] = generations
        
        setupTableCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        
        self.settingsTable.contentInset.top = 64
    }
    
    
    func setupNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 64))
        let navItem = UINavigationItem(title: "Settings")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(closeSettings))
        navItem.rightBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    func closeSettings() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setupTableCells() {
        let switchTableCellNib = UINib(nibName: String(describing: SettingsSwitchTableCell.self), bundle: nil)
        self.settingsTable.register(switchTableCellNib, forCellReuseIdentifier: CellType.toggle.rawValue)
    }
    
}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = settingsData.keys.index(settingsData.keys.startIndex, offsetBy: indexPath.section)
        let key = settingsData.keys[index]
        
        if let field = self.settingsData[key]?[indexPath.row] {
        
            if let cell = tableView.dequeueReusableCell(withIdentifier: field.cellType.rawValue, for: indexPath) as? SettingsSwitchTableCell {
                cell.setup(field: field)
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keys = self.settingsData.keys
        let index = keys.index(keys.startIndex, offsetBy: section)
        return keys[index]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsData.keys.count
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = settingsData.keys.index(settingsData.keys.startIndex, offsetBy: section)
        let key = settingsData.keys[index]
        
        if let sectionArray = settingsData[key] {
            return sectionArray.count
        }
        
        return 0
    }

    
}


enum SettingKey: String {
    case none   = ""
    case genI   = "genI"
    case genII  = "genII"
    case genIII = "genIII"
    case genIV  = "genIV"
    case genV   = "genV"
    case genVI  = "genVI"
    case genVII = "genVII"
}

class SettingsTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var field: SettingTableField?
    
    var title: String! {
        didSet {
            if let _ = self.titleLabel {
                self.titleLabel.text = title
            }
        }
    }
    var settingKey: SettingKey!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.title = ""
        self.settingKey = .none
    }
    
    
    public func setup(field: SettingTableField) {
        self.field = field
        
        self.title = field.title
        self.settingKey = field.value
    }
}

class SettingsSwitchTableCell: SettingsTableCell {
    
    @IBOutlet weak var toggle: UISwitch!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func setup(field: SettingTableField) {
        super.setup(field: field)
        
        self.toggle.setOn(field.switchOn, animated: true)
        
        self.toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
    }
    
    func toggleChanged(sender: UISwitch) {
        if let key = self.settingKey {
            UserDefaults.standard.set(sender.isOn, forKey: key.rawValue)
        }
    }
    
}


