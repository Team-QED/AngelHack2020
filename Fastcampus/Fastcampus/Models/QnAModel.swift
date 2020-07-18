//
//  QnAModel.swift
//  Fastcampus
//
//  Created by Lee on 2020/07/16.
//  Copyright © 2020 Kira. All rights reserved.
//

import Foundation

struct Qna {
  let documentID: String
  let data: QnAModel
}

struct QnAModel: Codable {
  let playTime: Int64
  let title: String
  let userID: String
  var isDone: Bool
  var messages: [Message]
//  var selectedMessageID
}

struct Message: Codable {
  let userID: String
  let message: String
}
