//
//  Observable.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 17/04/24.
//

import Foundation
class Observable<T> {
    var value: T {
        didSet {
            for item in self.listener {
                item?(value)
            }
        }
    }
    func append(_ value: T) {
        
    }
    private var listener: [((T) -> Void)?] = []

    init(_ value: T) {
        self.value = value
    }
    func bind(_ closure: @escaping (T) -> Void) {
        listener.append(closure)
    }
}

class ObservableCollection<T: RangeReplaceableCollection> {
    var value: T {
        didSet {
            for item in self.listener {
                item?(value)
            }
        }
    }
    func append(_ newElement: T.Element) {
        self.value.append(newElement)
        for item in self.listener {
            item?(value)
        }
    }
    func append(_ newElements: T) {
        self.value.append(contentsOf: newElements)
        for item in self.listener {
            item?(value)
        }
    }
    private var listener: [((T) -> Void)?] = []

    init(_ value: T) {
        self.value = value
    }
    func bind(_ closure: @escaping (T) -> Void) {
        listener.append(closure)
    }
}
