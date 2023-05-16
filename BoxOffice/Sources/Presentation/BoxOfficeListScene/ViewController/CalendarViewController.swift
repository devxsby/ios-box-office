//
//  CalendarViewController.swift
//  BoxOffice
//
//  Created by Mason Kim on 2023/05/16.
//

import UIKit

// MARK: - Delegate Protocol

protocol CalendarViewControllerDelegate: AnyObject {
    func calendarViewController(_ calendarView: CalendarViewController, didSelectDate dateComponents: DateComponents?)
}

// MARK: - CalendarViewController

final class CalendarViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: CalendarViewControllerDelegate?
    
    private enum Constants {
        static let initialDate: Date = .now.previousDate
    }
    
    // MARK: - UI Components
    
    private let calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        calendarView.availableDateRange = DateInterval(start: .distantPast, end: Constants.initialDate)
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: Constants.initialDate)
        selection.selectedDate = dateComponents
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
