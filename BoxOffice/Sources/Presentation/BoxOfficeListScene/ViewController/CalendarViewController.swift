//
//  CalendarViewController.swift
//  BoxOffice
//
//  Created by Mason Kim on 2023/05/16.
//

import UIKit

protocol CalendarViewControllerDelegate: AnyObject {
    func calendarViewController(_ calendarView: CalendarViewController, didSelectDate dateComponents: DateComponents?)
}

final class CalendarViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: CalendarViewControllerDelegate?
    
    // MARK: - UI Components
    
    private let calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        calendarView.availableDateRange = DateInterval(start: .distantPast, end: .now.previousDate)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.locale = Locale(identifier: "ko_KR")
        return calendarView
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Public
    
    func configure(selectedDate date: Date) {
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
        calendarView.visibleDateComponents = dateComponents
    }
}

// MARK: - UI & Layout

extension CalendarViewController {
    
    private func setup() {
        setUI()
        setLayout()
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        setCalendarViewSelection()
    }
    
    private func setLayout() {
        view.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: view.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setCalendarViewSelection() {
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
    }
}

// MARK: - UICalendarSelectionSingleDateDelegate

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        delegate?.calendarViewController(self, didSelectDate: dateComponents)
        dismiss(animated: true)
    }
}
