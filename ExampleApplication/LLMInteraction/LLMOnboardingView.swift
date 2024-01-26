//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziLLMOpenAI
import SpeziOnboarding
import SwiftUI


/// Provide an onboarding flow for the LLM demo in ``LLMInteraction``.
struct LLMOnboardingView: View {
    @Binding var showOnboarding: Bool
    
    
    var body: some View {
        OnboardingStack(onboardingFlowComplete: !$showOnboarding) {
            // OpenAI Onboarding
            LLMOpenAITokenOnboarding()
            
            // Local Onboarding
            // LLMLocalDownloadOnboarding()
        }
            .interactiveDismissDisabled(showOnboarding)
    }
}
