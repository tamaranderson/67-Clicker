import SwiftUI
import StoreKit

class PurchaseManager: NSObject, ObservableObject {
    @Published var isPremium: Bool = false
    @Published var products: [SKProduct] = []
    
    private var productRequest: SKProductsRequest?
    private let productID = "com.yourcompany.67clicker.premium" // Replace with your actual product ID
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        loadPremiumStatus()
        fetchProducts()
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    func fetchProducts() {
        let productIDs = Set([productID])
        productRequest = SKProductsRequest(productIdentifiers: productIDs)
        productRequest?.delegate = self
        productRequest?.start()
    }
    
    func purchasePremium() {
        guard let product = products.first else {
            print("No product available")
            return
        }
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    private func loadPremiumStatus() {
        isPremium = UserDefaults.standard.bool(forKey: "isPremium")
    }
    
    private func savePremiumStatus() {
        UserDefaults.standard.set(isPremium, forKey: "isPremium")
    }
}

// MARK: - SKProductsRequestDelegate
extension PurchaseManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
            
            if !response.products.isEmpty {
                print("Products loaded: \(response.products.map { $0.localizedTitle })")
            }
            
            if !response.invalidProductIdentifiers.isEmpty {
                print("Invalid product IDs: \(response.invalidProductIdentifiers)")
            }
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load products: \(error.localizedDescription)")
    }
}

// MARK: - SKPaymentTransactionObserver
extension PurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                completePurchase(transaction)
            case .restored:
                completePurchase(transaction)
            case .failed:
                failedPurchase(transaction)
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func completePurchase(_ transaction: SKPaymentTransaction) {
        DispatchQueue.main.async {
            self.isPremium = true
            self.savePremiumStatus()
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func failedPurchase(_ transaction: SKPaymentTransaction) {
        if let error = transaction.error as? SKError {
            if error.code != .paymentCancelled {
                print("Purchase failed: \(error.localizedDescription)")
            }
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}
