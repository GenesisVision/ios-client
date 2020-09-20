//
// FeeType.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

public enum FeeType: String, Codable {
    case undefined = "Undefined"
    case gvProgramEntry = "GvProgramEntry"
    case gvProgramSuccess = "GvProgramSuccess"
    case gvProgramSuccessSum = "GvProgramSuccessSum"
    case gvFundEntry = "GvFundEntry"
    case gvGmGvtHolderFee = "GvGmGvtHolderFee"
    case gvGmRegularFee = "GvGmRegularFee"
    case managerProgramEntry = "ManagerProgramEntry"
    case managerProgramSuccess = "ManagerProgramSuccess"
    case managerProgramSuccessSum = "ManagerProgramSuccessSum"
    case managerProgramManagement = "ManagerProgramManagement"
    case managerFundEntry = "ManagerFundEntry"
    case managerFundExit = "ManagerFundExit"
    case gvWithdrawal = "GvWithdrawal"
    case gvConvertingFiat = "GvConvertingFiat"
    case managerSignalMasterSuccessFee = "ManagerSignalMasterSuccessFee"
    case managerSignalMasterVolumeFee = "ManagerSignalMasterVolumeFee"
    case gvSignalSuccessFee = "GvSignalSuccessFee"
    case gvSignalVolumeFee = "GvSignalVolumeFee"
    case gvFundTrade = "GvFundTrade"
}