//
//  EmployeeDetailSwiftUIView.swift
//  Nidhi_Bhadasia_102722
//
//  Created by Guest1 on 10/28/22.
//

import SwiftUI

struct EmployeeDetailSwiftUIView: View {
    let employee: Employee
    
    private var phoneLink: URL? {
        guard let phoneNumber = employee.phoneNumber,
              let phoneLink = URL(string: "tel:\(phoneNumber)") else { return nil }
        return phoneLink
    }
    
    private var emailLink: URL? {
        guard let email = employee.email,
              let mailLink = URL(string: "mailto:\(email)") else { return nil }
        return mailLink
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 10) {
                if let photoURLLarge = employee.photoURLSmall,
                   let url = URL(string: photoURLLarge) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(.primary, lineWidth: 1)
                            )
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: 160, maxHeight: 160)
                }
                Text(employee.name)
                    .font(.title)
                if let bio = employee.bio {
                    Text(bio)
                        .multilineTextAlignment(.center)
                }
                Divider()
            }
            .padding(.horizontal)
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Label(employee.team, systemImage: "person.and.person")
                    if let email = employee.email, let mailLink = emailLink {
                        Link(destination: mailLink) {
                            Label(email, systemImage: "mail")
                        }
                    }
                    if let phoneNumber = employee.phoneNumber, let phoneLink = phoneLink {
                        Link(destination: phoneLink) {
                            Label(phoneNumber, systemImage: "phone")
                        }
                    }
                }
                .padding(.horizontal)
                .font(.body)
                Spacer()
            }
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
        .foregroundColor(.primary)
        .navigationBarTitle("Employee Info", displayMode: .inline)
    }
}

struct EmployeeDetailSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeDetailSwiftUIView(employee: .mocked)
    }
}
