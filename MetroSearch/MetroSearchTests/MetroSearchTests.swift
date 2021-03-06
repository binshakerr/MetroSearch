//
//  MetroSearchTests.swift
//  MetroSearchTests
//
//  Created by Eslam Shaker on 10/11/2021.
//

import XCTest
import RxSwift
import RxTest
@testable import MetroSearch

class MetroSearchTests: XCTestCase {
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var searchViewModel: SearchViewModelProtocol!
    var searchData: Data!
    var detailsViewModel: ObjectDetailsViewModelProtocol!
    var objectDetailsData: Data!
    var objectRepository: MockObjectRepository!
    let timeOut: Double = 10

    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        objectRepository = MockObjectRepository()
        searchViewModel = SearchViewModel(objectRepository: objectRepository)
        detailsViewModel = ObjectDetailsViewModel(objectRepository: objectRepository)
    }

    override func tearDown() {
        searchViewModel = nil
        searchData = nil

        detailsViewModel = nil
        objectDetailsData = nil

        objectRepository = nil
    }

    func test_SearchViewModel_InitialState() {
        XCTAssertTrue(searchViewModel.outputs.dataSubject.value.isEmpty)
        XCTAssertEqual(searchViewModel.outputs.screenTitle, "The Metropolitan Museum of Art")
    }

    func test_Search_Success() {
        // Given
        searchData = Utils.MockResponseType.SearchFullMock.sampleDataFor(self)
        let decodedItem = try? JSONDecoder().decode(SearchResult.self, from: searchData)
        objectRepository.searchStubData = decodedItem

        // When
        let searchObserver = scheduler.createObserver([Int].self)
        searchViewModel
            .outputs
            .dataSubject
            .bind(to: searchObserver)
            .disposed(by: disposeBag)
        scheduler
            .createColdObservable([.next(10, "horse")])
            .bind(to: searchViewModel.inputs.searchSubject)
            .disposed(by: disposeBag)
        scheduler.start()

        // Then
        let searchElement = searchObserver.events.last?.value.element
        XCTAssertEqual(searchElement?.count, 184)
    }
    
    func test_Search_EmptyResult() {
        // Given
        searchData = Utils.MockResponseType.SearchEmptyMock.sampleDataFor(self)
        let decodedItem = try? JSONDecoder().decode(SearchResult.self, from: searchData)
        objectRepository.searchStubData = decodedItem

        // When
        let searchObserver = scheduler.createObserver([Int].self)
        searchViewModel
            .outputs
            .dataSubject
            .bind(to: searchObserver)
            .disposed(by: disposeBag)
        scheduler
            .createColdObservable([.next(10, "lkfnongrov frfmwrformn")])
            .bind(to: searchViewModel.inputs.searchSubject)
            .disposed(by: disposeBag)
        scheduler.start()

        // Then
        let searchElement = searchObserver.events.last?.value.element
        XCTAssertEqual(searchElement, [])
    }
    
    
    func test_DetailsViewModel_InitialState() {
        XCTAssertNil(detailsViewModel.outputs.dataSubject.value)
    }
    
    func test_ObjectDetails_Success(){
        // Given
        objectDetailsData = Utils.MockResponseType.ObjectDetailsSuccessMock.sampleDataFor(self)
        let decodedItem = try? JSONDecoder().decode(MuseumItem.self, from: objectDetailsData)
        objectRepository.objectStubData = decodedItem

        // When
        let detailsObserver = scheduler.createObserver(MuseumItem?.self)
        detailsViewModel
            .outputs
            .dataSubject
            .bind(to: detailsObserver)
            .disposed(by: disposeBag)
        scheduler
            .createColdObservable([.next(10, 35772)])
            .bind(to: detailsViewModel.inputs.objectID)
            .disposed(by: disposeBag)
        scheduler.start()

        // Then
        if let detailsElement = detailsObserver.events.last?.value.element {
            XCTAssertEqual(detailsElement?.objectID ?? 0, 35772)
            XCTAssertEqual(detailsElement?.title ?? "", "Armor for Man and Horse")
        }
    }
    
    func test_ObjectDetails_Failure(){
        // Given
        objectDetailsData = Utils.MockResponseType.ObjectDetailsFailureMock.sampleDataFor(self)
        let decodedItem = try? JSONDecoder().decode(MuseumItem.self, from: objectDetailsData)
        objectRepository.objectStubData = decodedItem

        // When
        let detailsObserver = scheduler.createObserver(MuseumItem?.self)
        detailsViewModel
            .outputs
            .dataSubject
            .bind(to: detailsObserver)
            .disposed(by: disposeBag)
        scheduler
            .createColdObservable([.next(10, 924894584953)])
            .bind(to: detailsViewModel.inputs.objectID)
            .disposed(by: disposeBag)
        scheduler.start()

        // Then
        let detailsElement = detailsObserver.events.last?.value.element
        XCTAssertEqual(detailsElement??.objectID, nil)
    }
    
}
