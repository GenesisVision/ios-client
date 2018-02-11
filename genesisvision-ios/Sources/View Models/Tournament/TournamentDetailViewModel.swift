//
//  TournamentDetailViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class TournamentDetailViewModel {
    // MARK: - Variables
    var router: TournamentDetailRouter
    private var participantViewModel: ParticipantViewModel!
    
    // MARK: - Init
    init(withRouter router: TournamentDetailRouter, with participantViewModel: ParticipantViewModel) {
        self.router = router
        self.participantViewModel = participantViewModel
    }
    
    func getNickname() -> String {
        return participantViewModel.name ?? ""
    }
    
    func getModel() -> ParticipantViewModel {
        return participantViewModel
    }
}
