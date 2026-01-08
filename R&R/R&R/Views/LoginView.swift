//
//  LoginView.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
//

import AuthenticationServices
import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("email") var email: String = ""
    @AppStorage("first name") var firstName: String = ""
    @AppStorage("userId") var userId: String = ""

    
    var body: some View {
        NavigationView {
            VStack {
                HeaderVeiw(subTitle: "Welcome!", color: Color("Yellow"))
                
                Spacer()
                
                VStack(spacing: 16) {
                    Text("Sign in to manage your album collection")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    SignInWithAppleButton(.continue) { request in
                        request.requestedScopes = [.email, .fullName]
                    } onCompletion: { result in
                        switch result {
                        case .success(let auth):
                            switch auth.credential {
                            case let credential as ASAuthorizationAppleIDCredential:
                                self.userId = credential.user
                                self.email = credential.email ?? ""
                                self.firstName = credential.fullName?.givenName ?? ""
                            default:
                                break
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                    .frame(height: 55)
                    .padding(.horizontal, 32)
                }
                .padding(.bottom, 100)
                
                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
}
