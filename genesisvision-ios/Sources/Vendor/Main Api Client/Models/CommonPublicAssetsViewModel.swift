//
// CommonPublicAssetsViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct CommonPublicAssetsViewModel: Codable {


    public var programs: ProgramDetailsListItemItemsViewModel?

    public var funds: FundDetailsListItemItemsViewModel?

    public var follows: FollowDetailsListItemItemsViewModel?

    public var managers: PublicProfileItemsViewModel?
    public init(programs: ProgramDetailsListItemItemsViewModel? = nil, funds: FundDetailsListItemItemsViewModel? = nil, follows: FollowDetailsListItemItemsViewModel? = nil, managers: PublicProfileItemsViewModel? = nil) { 
        self.programs = programs
        self.funds = funds
        self.follows = follows
        self.managers = managers
    }

}
