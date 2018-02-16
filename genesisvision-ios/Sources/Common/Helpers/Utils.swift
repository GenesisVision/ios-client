//
//  Utils.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 12.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

func getFileURL(fileName: String) -> URL? {
    return URL(string: Constants.Api.filePath + fileName)
}
