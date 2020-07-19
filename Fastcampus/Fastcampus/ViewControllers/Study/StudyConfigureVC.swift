//
//  StudyConfigureVC.swift
//  Fastcampus
//
//  Created by Lee on 2020/07/15.
//  Copyright © 2020 Kira. All rights reserved.
//

import UIKit
import Firebase

enum StudyConfigureType {
  case create
  case join
}

class StudyConfigureVC: ViewController<StudyConfigureView> {
  var studyConfigureType: StudyConfigureType = .create {
    didSet {
      if studyConfigureType == .join {
        customView.setJoinStyle(study: study!)
      }
    }
  }
  private let lecture: Lecture
  private let chapter: ChapterModel
  private let unit: UnitModel
  private var study: StudyModel?
  
  init(lecture: Lecture, chapter: ChapterModel, unit: UnitModel, study: StudyModel? = nil) {
    self.lecture = lecture
    self.chapter = chapter
    self.unit = unit
    self.study = study
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    addKeyboardNotification()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }
}



// MARK: - UI

extension StudyConfigureVC {
  private func setUI() {
    view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    customView.delegate = self
  }
  
  private func addKeyboardNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotificationAction(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotificationAction(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc private func keyboardNotificationAction(_ notification: Notification) {
    customView.keyboardAction(notification)
  }
}



// MARK: - StudyConfigureViewDelegate

extension StudyConfigureVC: StudyConfigureViewDelegate {
  func cancelDidTap() {
    self.dismiss(animated: true)
  }
  
  func createDidTap(title: String?, moth: Int?, day: Int?, hour: Int?, minute: Int?, fixed: Int?, rule: String?) {
    guard let title = title else {
      alertNormal(title: "스터디 제목을 입력해주세요")
      return
    }
    
    guard
      let moth = moth, let day = day, let hour = hour, let minute = minute,
      let date = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2020, month: moth, day: day, hour: hour, minute: minute).date
      else {
        alertNormal(title: "스터디 오픈 시간을 입력해주세요")
        return
    }
    
    guard let fixed = fixed else {
      alertNormal(title: "정원을 정해주세요")
      return
    }
    
    
    guard let rule = rule else {
      alertNormal(title: "규칙을 정해주세요")
      return
    }
    let unitTitle = "\(chapter.title) - \(unit.title)"
    let mStudy = StudyModel(
      title: title,
      lectureID: lecture.documentID,
      lectureTitle: lecture.title,
      chapterID: chapter.index,
      unitID: unit.index,
      unitTitle: unitTitle,
      unitDescription: unit.description,
      date: Timestamp(date: date),
      fixed: fixed,
      rule: rule,
      userIDs: [SignService.uid],
      qnaIDs: [String](),
      inProcess: .wait
    )
    
    if studyConfigureType == .create {
      presentIndicatorViewController()
      StudyService.createStudy(studyModel: mStudy) {
        self.dismissIndicatorViewController()
        self.dismiss(animated: true)
      }
    } else {
      //TODO:- 스터디 참여하기
    }
    
    
  }
}

