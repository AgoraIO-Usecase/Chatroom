//
//  CharactersViewController.swift
//  AgoraChatRoom
//
//  Created by CavanSu on 2018/8/15.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

protocol CharactersVCDelegate: NSObjectProtocol {
    func charactersVC(vc: CharactersViewController, didSelectedCharacter character: EffectCharacters)
    func charactersVCDidCancelSelectedRole(vc: CharactersViewController)
}

class CharactersViewController: UITableViewController {
    let CharactersList = EffectCharacters.allCases
    var selectedCharacter: EffectCharacters?
    weak var delegate: CharactersVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        let height = CharactersList.count * 44
        preferredContentSize = CGSize(width: 200, height: height)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CharactersList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Characters")!
        let Character = CharactersList[indexPath.row]
        cell.textLabel?.text = Character.description()
        if let selectedCharacter = selectedCharacter, selectedCharacter.rawValue == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消角色选中
        if let character = selectedCharacter, character.rawValue == indexPath.row {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .none
            self.selectedCharacter = nil
            
            delegate?.charactersVCDidCancelSelectedRole(vc: self)
            return
        }
        
        // 如果在此次选中之前已经有选中的角色，则先取消该选中角色
        if let character = selectedCharacter {
            let selectedCharacterPath = IndexPath(row: character.rawValue, section: 0)
            let cell = tableView.cellForRow(at: selectedCharacterPath)
            cell?.accessoryType = .none
        }
        
        // 选中角色
        selectedCharacter = EffectCharacters(rawValue: indexPath.row)
        delegate?.charactersVC(vc: self, didSelectedCharacter: selectedCharacter!)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
}
