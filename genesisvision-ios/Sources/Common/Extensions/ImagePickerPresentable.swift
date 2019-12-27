//
//  ImagePickerPresentable.swift
//  genesisvision-ios
//
//  Created by George on 12/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol ImagePickerPresentable: class {
    var choosePhotoButton: UIButton { get }
    
    func showImagePicker()
    func selected(pickedImage: UIImage?, pickedImageURL: URL?)
}

extension ImagePickerPresentable where Self: UIViewController {
    
    fileprivate func pickerControllerActionFor(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            let pickerController           = UIImagePickerController()
            pickerController.navigationBar.isTranslucent = false
            pickerController.delegate      = ImagePickerHelper.shared
            pickerController.sourceType    = type
            pickerController.allowsEditing = true
            
//            pickerController.modalPresentationStyle = .pageSheet
//            pickerController.navigationBar.barStyle = .black
//            pickerController.navigationBar.barTintColor = UIColor.BaseView.bg
//            pickerController.navigationBar.tintColor = UIColor.Cell.title
//            pickerController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.Cell.title, NSAttributedString.Key.font: UIFont.getFont(.semibold, size: 18.0)]
            
            self.present(pickerController, animated: true)
        }
    }
    
    func showImagePicker() {
        ImagePickerHelper.shared.delegate = self
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.pickerControllerActionFor(for: .camera, title: "Take Photo") {
            optionMenu.addAction(action)
        }
        if let action = self.pickerControllerActionFor(for: .photoLibrary, title: "Select From Library") {
            optionMenu.addAction(action)
        }
        
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        optionMenu.popoverPresentationController?.sourceView = choosePhotoButton
        optionMenu.popoverPresentationController?.sourceRect = choosePhotoButton.bounds
        
        self.present(optionMenu, animated: true)
    }
}

fileprivate class ImagePickerHelper: NSObject {
    
    weak var delegate: ImagePickerPresentable?
    
    fileprivate struct `Static` {
        fileprivate static var instance: ImagePickerHelper?
    }
    
    fileprivate class var shared: ImagePickerHelper {
        if ImagePickerHelper.Static.instance == nil {
            ImagePickerHelper.Static.instance = ImagePickerHelper()
        }
        
        return ImagePickerHelper.Static.instance!
    }
    
    fileprivate func dispose() {
        ImagePickerHelper.Static.instance = nil
    }
    
    func picker(picker: UIImagePickerController, pickedImage: UIImage?, pickedImageURL: URL?) {
        self.delegate?.selected(pickedImage: pickedImage, pickedImageURL: pickedImageURL)
        
        picker.dismiss(animated: true, completion: nil)
        self.delegate = nil
        self.dispose()
    }
}

extension ImagePickerHelper: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker(picker: picker, pickedImage: nil, pickedImageURL: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        var data: Data?
        let fileName = "avatar.jpg"
        var selectedImage: UIImage?
        
        if #available(iOS 11.0, *) {
            if let refURL = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.imageURL)] as! URL? {
                if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
                    data = image.jpegData(compressionQuality: 0.5)
                    selectedImage = image
                } else {
                    do {
                        data = try Data(contentsOf: refURL)
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                    
                    if let data = data {
                        selectedImage = UIImage(data: data)
                    }
                }
            } else if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
                data = image.jpegData(compressionQuality: 0.5)
                selectedImage = image
            }
        } else {
            if let refURL = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.referenceURL)] as! URL? {
                if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
                    data = image.jpegData(compressionQuality: 0.5)
                    selectedImage = image
                } else {
                    do {
                        data = try Data(contentsOf: refURL)
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                    
                    if let data = data {
                        selectedImage = UIImage(data: data)
                    }
                }
            } else if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
                data = image.jpegData(compressionQuality: 0.5)
                selectedImage = image
            }
        }
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileName)
        
        do {
            try data?.write(to: fileURL, options: .atomicWrite)
        } catch {
            print("Unable to write data: \(error)")
        }
        
        self.picker(picker: picker, pickedImage: selectedImage, pickedImageURL: fileURL)
    }
}

extension ImagePickerHelper: UINavigationControllerDelegate {
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
