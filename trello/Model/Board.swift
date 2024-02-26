//
//  Board.swift
//  trello
//
//  Created by Gytis Ptasinskas on 22/02/2024.
//

import Foundation

// Main Board structure
struct Board: Codable, Identifiable {
    let id: String
    let nodeId: String?
    let name: String
    let desc: String?
    let closed: Bool?
    let dateClosed: String?
    let idOrganization: String?
    let idEnterprise: String?
    let limits: Limits?
    let pinned: Bool?
    let starred: Bool?
    let url: String?
    let prefs: Prefs?
    let shortLink: String?
    let subscribed: Bool?
    let labelNames: [String: String]?
    let dateLastActivity: String?
    let dateLastView: String?
    let shortUrl: String?
    let idTags: [String]?
    let datePluginDisable: String?
    let creationMethod: String?
    let ixUpdate: String?
    let templateGallery: String?
    let enterpriseOwned: Bool?
    let idBoardSource: String?
    let premiumFeatures: [String]?
    let idMemberCreator: String?
    let memberships: [Membership]?
}

// Nested structures
struct Limits: Codable {
    let attachments: AttachmentLimits
    let boards: BoardLimits
    let cards: CardLimits
    let checklists: ChecklistLimits
    let stickers: StickerLimits
    let reactions: ReactionLimits
}

struct AttachmentLimits: Codable {
    let perBoard: LimitDetail
    let perCard: LimitDetail
}

struct BoardLimits: Codable {
    let totalMembersPerBoard: LimitDetail
    let totalAccessRequestsPerBoard: LimitDetail
}

struct CardLimits: Codable {
    let openPerBoard: LimitDetail
    let openPerList: LimitDetail
    let totalPerBoard: LimitDetail
    let totalPerList: LimitDetail
}

struct ChecklistLimits: Codable {
    let perBoard: LimitDetail
    let perCard: LimitDetail
}

struct StickerLimits: Codable {
    let perCard: LimitDetail
}

struct ReactionLimits: Codable {
    let perAction: LimitDetail
    let uniquePerAction: LimitDetail
}

struct LimitDetail: Codable {
    let status: String
    let disableAt: Int
    let warnAt: Int
}

struct Prefs: Codable {
    let permissionLevel: String
    let hideVotes: Bool
    let voting: String
    let comments: String
    let invitations: String
    let selfJoin: Bool
    let cardCovers: Bool
    let cardCounts: Bool?
    let isTemplate: Bool
    let cardAging: String
    let calendarFeedEnabled: Bool
    let background: String
    let backgroundColor: String?
    let backgroundImage: String?
    let backgroundTile: Bool?
    let backgroundBrightness: String
    let backgroundImageScaled: [BackgroundImageScaled]?
    let backgroundBottomColor: String?
    let backgroundTopColor: String?
    let canBePublic: Bool
    let canBeEnterprise: Bool
    let canBeOrg: Bool
    let canBePrivate: Bool
    let canInvite: Bool
}

struct BackgroundImageScaled: Codable {
    let width: Int
    let height: Int
    let url: String
}

struct Membership: Codable, Identifiable {
    let id: String
    let idMember: String
    let memberType: String
    let unconfirmed: Bool
    let deactivated: Bool
}
