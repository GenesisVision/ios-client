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
    
    fileprivate func pickerControllerActionFor(for type: UIImagePickerControllerSourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            let pickerController           = UIImagePickerController()
            pickerController.delegate      = ImagePickerHelper.shared
            pickerController.sourceType    = type
            pickerController.allowsEditing = true
            
            pickerController.navigationBar.barStyle = .black
            pickerController.navigationBar.barTintColor = UIColor.BaseView.bg
            pickerController.navigationBar.tintColor = UIColor.Cell.title
            pickerController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.Cell.title, NSAttributedStringKey.font: UIFont.getFont(.semibold, size: 18.0)]
            
            self.present(pickerController, animated: true)
        }
    }
    
    func showImagePicker() {
        ImagePickerHelper.shared.delegate = self
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.view.tintColor = UIColor.BaseView.bg
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var data: Data?
        let fileName = "avatar.jpg"
        var selectedImage: UIImage?
        
        if #available(iOS 11.0, *) {
            if let refURL = info[UIImagePickerControllerImageURL] as! URL? {
                if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                    data = UIImageJPEGRepresentation(image, 0.5)
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
            } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                data = UIImageJPEGRepresentation(image, 0.5)
                selectedImage = image
            }
        } else {
            if let refURL = info[UIImagePickerControllerReferenceURL] as! URL? {
                if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                    data = UIImageJPEGRepresentation(image, 0.5)
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
            } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                data = UIImageJPEGRepresentation(image, 0.5)
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
