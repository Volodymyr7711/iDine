//
//  CheckoutView.swift
//  iDine
//
//  Created by Volodymyr Mendyk on 15.03.2021.
//

import SwiftUI

struct CheckoutView: View {
    
    @EnvironmentObject var order: Order
    
    static let paymentTypes = ["Cash", "Credit Cards", "IDine points"]
    
    @State private var paymentType = "Cash"
    let tipAmounts = [10, 15, 20, 25, 0]
    @State private var tipAmount = 15
    @State private var addLoyaltyDetails = false
    @State private var loyaltyNumber = ""
    @State private var showingPaymentAlert = false
    
    var totalPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        let total = Double(order.total)
        let tipValue = total / 100 * Double(tipAmount)
        
        return formatter.string(from: NSNumber(value: total + tipValue)) ?? "$0"
    }
    
    
    var body: some View {
        Form {
            Section {
                Picker("How do you want to pay?", selection: $paymentType) {
                    ForEach(Self.paymentTypes, id: \.self) {
                        Text($0)
                    }
                }
                Toggle("Add iDine loyalty card", isOn: $addLoyaltyDetails.animation())
                if addLoyaltyDetails {
                    TextField("Enter your iDine ID", text: $loyaltyNumber)
                }
            }
            Section(header: Text("Add a tip?")) { Picker("Percentage:", selection: $tipAmount) {
            ForEach(tipAmounts, id: \.self) { Text("\($0)%")
            } }
            .pickerStyle(SegmentedPickerStyle()) }
            Section(header: Text("TOTAL: \(totalPrice)") .font(.largeTitle)) {
                Button("Confirm Order")  {
                    showingPaymentAlert.toggle()
                }
            }
            .alert(isPresented: $showingPaymentAlert) {
                Alert(title: Text("Order confirmed"), message: Text("Your total was \(totalPrice) - thank You!"),dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarTitle(Text("Payment"), displayMode: .inline)
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static let order = Order()
    static var previews: some View {
        CheckoutView().environmentObject(Order())
    }
}
