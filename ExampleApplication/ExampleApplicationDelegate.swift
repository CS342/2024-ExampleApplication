//
// This source file is part of the Example Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziAccount
import SpeziFirebaseAccount
import SpeziFirebaseStorage
import SpeziFirestore
import SpeziHealthKit
import SpeziLLM
import SpeziLLMLocal
import SpeziLLMOpenAI
import SpeziMockWebService
import SpeziOnboarding
import SpeziScheduler
import SwiftUI


class ExampleApplicationDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: ExampleApplicationStandard()) {
            if !FeatureFlags.disableFirebase {
                AccountConfiguration(configuration: [
                    .requires(\.userId),
                    .requires(\.name),

                    // additional values stored using the `FirestoreAccountStorage` within our Standard implementation
                    .collects(\.genderIdentity),
                    .collects(\.dateOfBirth)
                ])

                if FeatureFlags.useFirebaseEmulator {
                    FirebaseAccountConfiguration(
                        authenticationMethods: [.emailAndPassword, .signInWithApple],
                        emulatorSettings: (host: "localhost", port: 9099)
                    )
                } else {
                    FirebaseAccountConfiguration(authenticationMethods: [.emailAndPassword, .signInWithApple])
                }
                firestore
                if FeatureFlags.useFirebaseEmulator {
                    FirebaseStorageConfiguration(emulatorSettings: (host: "localhost", port: 9199))
                } else {
                    FirebaseStorageConfiguration()
                }
            } else {
                MockWebService()
            }

            if HKHealthStore.isHealthDataAvailable() {
                healthKit
            }
            
            ExampleApplicationScheduler()
            OnboardingDataSource()
            
            LLMRunner {
                LLMLocalPlatform()
                LLMOpenAIPlatform()
            }
        }
    }
    
    
    private var firestore: Firestore {
        let settings = FirestoreSettings()
        if FeatureFlags.useFirebaseEmulator {
            settings.host = "localhost:8080"
            settings.cacheSettings = MemoryCacheSettings()
            settings.isSSLEnabled = false
        }
        
        return Firestore(
            settings: settings
        )
    }
    
    
    private var healthKit: HealthKit {
        HealthKit {
            CollectSamples(
                [
                    HKQuantityType(.stepCount),
                    HKQuantityType(.dietaryEnergyConsumed),
                    HKQuantityType(.dietaryProtein)
                ],
                deliverySetting: .anchorQuery(.afterAuthorizationAndApplicationWillLaunch)
            )
        }
    }
}
