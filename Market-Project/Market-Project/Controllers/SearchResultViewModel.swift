//
//  SearchResultViewModel.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/6/25.
//

import Foundation

/*
 강한 순환 참조
 output 로직:
 SearchResultVC - SearchResultVM - output(Observable의 클로저)
 SearchVC에 의해 push된 SearchResultVC는 [RC 1] 이다. 그후 output의 클로저에서 self가 캡쳐되므로 [RC 2]를 갖게 된다.
 만약 SearchResultVC가 pop된다면 RC가 1 줄어들지만, 여전히 클로저에 의한 [RC 1] 남아있어 메모리에서 유지될 것이다. 클로저가 메모리 할당 해제가 된다면 SearchResultVC도 [RC 0]이 되어 메모리 할당 해제가 되겠지만, 클로저는 SearchResultVC에 의해 [RC 1] 상태이기 때문에 서로에 의해 메모리에서 해제되지 않는다.
 만약 클로저가 self, 즉 SearchResultVC을 약하게 참조한다면 위의 관계가 해결된다. 왜냐하면 약한 참조는 RC에 영향을 주지 않기 때문이다. 따라서 화면에 push되었을 때, 클로저가 self(SearchResultVC)를 강하게 참조를 했을 때는 [RC 2]였지만 약하게 참조를 했을 때는 [RC 1]을 갖게 된다.
 그렇기 때문에 SearchResultVC가 dismiss되면 [RC 0]으로 SearchResultVC가 메모리에서 할당 해제되며, 내부 프로퍼티인 viewModel 또한 해제되고, 이 프로퍼티가 가리키던 SearchResultVM도 해제되고, 결국 VM의 프로퍼티였던 output 또한 해제된다. 이렇게 메모리 누수를 방지할 수 있다.
 
 input 로직:
 SearchResultVM - input(Observable의 클로저)
 VM과 클로저가 서로를 참조하고 있어 서로의 RC가 1씩 유지되게 되며 메모리 할당 해제가 일어나지 않게 된다. 따라서 클로저가 self(VM)을 약하게 참조해 VM의 RC가 클로저와는 관계없도록 구성해 순환 참조로 인한 메모리 누수를 방지할 수 있다.
 
 */

class SearchResultViewModel {
    
    // IN
    let inputLoadSearchResult: Observable<Void> = Observable(())
    let inputWillDisplayItems: Observable<IndexPath?> = Observable(nil)
    let inputSelectSort: Observable<Int> = Observable(0)
    
    // OUT
    let outputSearchWord: Observable<String?> = Observable(nil)
    let outputMarketItems: Observable<[MarketItem]> = Observable([])
    let outputShowErrorAlert: Observable<String> = Observable("")
    let outputTotalItemsCountString: Observable<String> = Observable("")
    let outputReloadData: Observable<Void> = Observable(())
    let outputScrollToTop: Observable<Void> = Observable(())
    
    // DATA
    private var start: Int = 1
    private var total: Int = 0
    private var sort: MarketItemSort = .sim
    
    init() {
        print("SearchResultViewModel init")
        
        inputLoadSearchResult.lazyBind { [weak self] _ in
            guard let self else { return }
            print("inputLoadSearchResult bind")
            self.loadMarketItems(sort: self.sort, isInitialLoad: true)
        }
        
        inputWillDisplayItems.lazyBind { [weak self] indexPath in
            guard let self else { return }
            print("inputWillDisplayItems bind")
            guard let indexPath else { return }
            self.willDisplay(at: indexPath)
        }
        
        inputSelectSort.lazyBind { [weak self] sortNumber in
            guard let self else { return }
            print("inputSelectSort bind")
            self.didSelectSort(sortNumber)
        }
    }
    
    deinit {
        print("SearchResultViewModel deinit")
    }
    
    private func loadMarketItems(sort: MarketItemSort, isInitialLoad: Bool) {
        guard let searchWord = outputSearchWord.value else { return }
        NetworkManager.shared.getShopList(searchWord: searchWord, sort: sort, start: String(start)) {(value, error) in
            if let error {
                self.outputShowErrorAlert.send(error)
                return
            }
            
            guard let value else { return }
            if isInitialLoad {
                self.start = 0
                self.outputMarketItems.send([])
                self.outputTotalItemsCountString.send(value.total.decimal() ?? "")
            }
            self.outputMarketItems.value.append(contentsOf: value.items)
            self.start += NetworkManager.Pagenation.market.display
            self.total = value.total
            self.outputReloadData.send(())
        }
    }
    
    private func willDisplay(at indexPath: IndexPath) {
        let items = outputMarketItems.value
        guard items.count != self.total else { return }
        
        if (items.count - 2) == indexPath.item {
            loadMarketItems(sort: sort, isInitialLoad: false)
        }
    }
    
    private func didSelectSort(_ sortNumber: Int) {
        guard let sort = MarketItemSort(rawValue: sortNumber) else {
            print("Unknown sort")
            return
        }
        guard self.sort != sort else {
            print("already selected")
            return
        }
        self.sort = sort
        self.outputScrollToTop.send()
        self.loadMarketItems(sort: sort, isInitialLoad: true)
    }
}
