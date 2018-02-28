//
//  TournamentDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 28.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class TournamentDataProvider: DataProvider {
    static func getTournamentParticipant(with participantID: String, completion: @escaping (_ participant: ParticipantViewModel?) -> Void) {
        
        guard let uuid = UUID(uuidString: participantID) else { return completion(nil) }
        
        TournamentAPI.apiTournamentParticipantGet(participantId: uuid) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: { (participantViewModel) in
                completion(participantViewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
}
