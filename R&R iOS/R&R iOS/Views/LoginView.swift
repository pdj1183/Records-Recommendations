//
//  LoginView.swift
//  R&R iOS
//
//  Created by Phillip Johnson on 12/30/23.
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
                //Header
                HeaderVeiw(subTitle: "Welcome!", color: Color("Yellow"))
                
                //Login Header
                
                    SignInWithAppleButton(.continue) { requst in
                        requst.requestedScopes = [.email, .fullName]
                    } onCompletion: { result in
                        
                        switch result{
                        case .success(let auth):
                            switch auth.credential {
                            case let credential as ASAuthorizationAppleIDCredential:
                                
                                // User Id
                                self.userId = credential.user
                                
                                // User Info
                                self.email = credential.email ?? ""
                                self.firstName = credential.fullName?.givenName ?? ""
                                
                                
                            default:
                                break
                            }
                            break
                            
                        case .failure(let error):
                            print(error)
                        }
                    
                        }
                    .signInWithAppleButtonStyle(
                        colorScheme == .dark ? .white : .black)
                .frame(height: 50)
                .padding()
                
                
                
            }
            Spacer()
        }
    }
}

#Preview {
    LoginView()
}
