import StoreKit
import Foundation

@MainActor
class StoreManager: ObservableObject {
    static let productID = "support_developer"

    // Set to true to simulate a completed donation for UI testing
    static let debugForceDonated = false

    @Published var isDonated: Bool = false

    private var transactionListener: Task<Void, Error>?

    init() {
        if Self.debugForceDonated {
            isDonated = true
        } else {
            isDonated = UserDefaults.standard.bool(forKey: "donated")
        }
        transactionListener = listenForTransactions()
        Task { await checkExistingEntitlements() }
    }

    deinit {
        transactionListener?.cancel()
    }

    func purchase() async {
        guard !Self.debugForceDonated else { return }
        do {
            let products = try await Product.products(for: [Self.productID])
            guard let product = products.first else { return }
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                setDonated()
            default:
                break
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }

    private func checkExistingEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.productID {
                setDonated()
            }
        }
    }

    private func listenForTransactions() -> Task<Void, Error> {
        let pid = Self.productID
        return Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                if case .verified(let transaction) = result,
                   transaction.productID == pid {
                    await MainActor.run { self.setDonated() }
                    await transaction.finish()
                }
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let value):
            return value
        }
    }

    private func setDonated() {
        isDonated = true
        UserDefaults.standard.set(true, forKey: "donated")
    }

    enum StoreError: Error {
        case failedVerification
    }
}
