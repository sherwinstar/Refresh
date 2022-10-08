//
//  SerialCodeViewController.swift
//  Refresh
//
//  Created by Shaolin Zhou on 2022/10/5.
//

import Cocoa

class SerialCodeViewController: NSViewController {
    @IBOutlet weak var serialLabel: NSTextField!
    @IBOutlet weak var msgLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        msgLabel.backgroundColor = .clear
        serialLabel.layer?.cornerRadius = 4
        serialLabel.delegate = self
        let license = UserDefaults.standard.string(forKey: "license")
        guard let license = license, !license.isEmpty else {
            return
        }
        msgLabel.stringValue = "License key verified."
        serialLabel.stringValue = license
    }
    
    func checkCode () {
        let str = serialLabel.stringValue.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if str.count < 2 {
            msgLabel.stringValue = "Wrong license key."
            return
        }
        let char: Character = str[str.index(str.startIndex, offsetBy: str.count - 1)]
        if !char.isNumber {
            msgLabel.stringValue = "Wrong license key."
            return
        }
        let last = Int(String(char)) ?? 0
        var index = 0
        var value = 0
        for ch in str {
            if ch.isNumber && index < str.count - 1 {
                let va = Int(String(ch)) ?? 0
                value += va
            }
            index += 1
        }
        
        if value / 10 == last {
            msgLabel.stringValue = "License key verified."
            UserDefaults.standard.setValue(str, forKey: "license")
        } else {
            msgLabel.stringValue = "Wrong license key."
        }
    }
}

extension SerialCodeViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertNewline(_:)) {
            if let modifierFlags = NSApplication.shared.currentEvent?.modifierFlags, (modifierFlags.rawValue & NSEvent.ModifierFlags.shift.rawValue) != 0 {
                checkCode()
                return true
            } else {
                checkCode()
                return true
            }
        }
        return false
    }
    
    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertNewline(_:)) {
            if let modifierFlags = NSApplication.shared.currentEvent?.modifierFlags, (modifierFlags.rawValue & NSEvent.ModifierFlags.shift.rawValue) != 0 {
                checkCode()
                return true
            } else {
                checkCode()
                return true
            }
        }
        return false
    }
}
