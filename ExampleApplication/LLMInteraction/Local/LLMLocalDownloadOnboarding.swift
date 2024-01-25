//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziLLMLocalDownload
import SpeziOnboarding
import SpeziViews
import SwiftUI


struct LLMLocalDownloadOnboarding: View {
    @Environment(OnboardingNavigationPath.self) private var onboardingNavigationPath
    
    
    var body: some View {
        LLMLocalDownloadView(
            llmDownloadUrl: LLMLocalDownloadManager.LLMUrlDefaults.phi2ModelUrl,
            llmStorageUrl: .cachesDirectory.appending(path: "llm.gguf")
        ) {
            onboardingNavigationPath.nextStep()
        }
    }
}


#Preview {
    OnboardingStack {
        LLMLocalDownloadOnboarding()
    }
}
