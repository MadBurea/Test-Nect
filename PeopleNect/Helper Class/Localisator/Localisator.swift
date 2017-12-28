//
//  Localisator.swift
//  Localisator_Demo-swift
//
//  Created by Michaël Azevedo on 10/02/2015.
//  Copyright (c) 2015 Michaël Azevedo. All rights reserved.
//

import UIKit

let kNotificationLanguageChanged        = "kNotificationLanguageChanged";

func Localization(string:String) -> String{
    return Localisator.sharedInstance.localizedStringForKey(key: string)
}

func SetLanguage(language:String) -> Bool {
    return Localisator.sharedInstance.setLanguage(newLanguage: language)
}

class Localisator {
   
    // MARK: - Private properties
    
    private let userDefaults                    = UserDefaults.standard
    var availableLanguagesArray         = ["English_en", "Portuguese_pt-BR"]
    private var dicoLocalisation:NSDictionary!
    
    
    private let kSaveLanguageDefaultKey         = "kSaveLanguageDefaultKey"
    
    // MARK: - Public properties
    
    var currentLanguage                         = "DeviceLanguage"
    
    // MARK: - Public computed properties
    
    var saveInUserDefaults:Bool {
        get {
            return (userDefaults.object(forKey: kSaveLanguageDefaultKey) != nil)
        }
        set {
            if newValue {
                userDefaults.set(currentLanguage, forKey: kSaveLanguageDefaultKey)
            } else {
                userDefaults.removeObject(forKey: kSaveLanguageDefaultKey)
            }
            userDefaults.synchronize()
        }
    }
    
    
    // MARK: - Singleton method
    
    class var sharedInstance :Localisator {
        
        struct Singleton {
            static let instance = Localisator()
        }
        
        return Singleton.instance
    }
    
    // MARK: - Init method
    init() {
        if userDefaults.object(forKey: "kSaveLanguageDefaultKey") == nil {
            userDefaults.set("English_en", forKey: "kSaveLanguageDefaultKey")
        }
        if let languageSaved = userDefaults.object(forKey: kSaveLanguageDefaultKey) as? String {
            if languageSaved != "DeviceLanguage" {
                self.loadDictionaryForLanguage(newLanguage: languageSaved)
            }
        }
    }
    
    // MARK: - Public custom getter
    
    func getArrayAvailableLanguages() -> [String] {
        return availableLanguagesArray
    }
    
 
    // MARK: - Private instance methods
    
    func loadDictionaryForLanguage(newLanguage:String) -> Bool {
        
        let arrayExt = newLanguage.components(separatedBy: "_")
        
        print("arrayExt is",arrayExt)
        
        for ext in arrayExt {
            
            var pathForFile = Bundle(for:object_getClass(self)).url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: ext)?.path
            
            print("path is",pathForFile)
            
            if let path = Bundle(for:object_getClass(self)).url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: ext)?.path {
                if FileManager.default.fileExists(atPath: path) {
                    currentLanguage = newLanguage
                    
                    print("currentLanguage",currentLanguage)

                    dicoLocalisation = NSDictionary(contentsOfFile: path)
                    
                    print("dicoLocalisation",currentLanguage)

                    return true
                }
            }
        }
        return false
    }
    
    func localizedStringForKey(key:String) -> String {
        
        if let dico = dicoLocalisation {
            if let localizedString = dico[key] as? String {
                return localizedString
            }  else {
                return key
            }
        } else {
            return NSLocalizedString(key, comment: key)
        }
    }
    
    func setLanguage(newLanguage:String) -> Bool {
        
        if (newLanguage == currentLanguage) || !availableLanguagesArray.contains(newLanguage) {
            return false
        }
        
        if newLanguage == "DeviceLanguage"
        {
            currentLanguage = newLanguage
            dicoLocalisation = nil
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationLanguageChanged), object: nil)
            return true
        } else if loadDictionaryForLanguage(newLanguage: newLanguage) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationLanguageChanged), object: nil)
            if saveInUserDefaults {
                userDefaults.set(currentLanguage, forKey: kSaveLanguageDefaultKey)
                userDefaults.synchronize()
            }
            return true
        }
        return false
    }
}

