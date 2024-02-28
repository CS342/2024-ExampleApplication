//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziLLM
import SpeziLLMLocal
import SpeziLLMOpenAI
import SwiftUI


/// Showcases a minimal demo of SpeziLLM
struct LLMInteraction: View {
    private static let llmOpenAISchema = LLMOpenAISchema(
        parameters: .init(
            modelType: .gpt4_turbo_preview,
            systemPrompt: "You're speaking in front of Stanford students, be as funny and ironic as possible."
        )
    ) {
        LLMOpenAIFunctionWeather()
    }
    private static let llmLocalSchema = LLMLocalSchema(
        modelPath: .cachesDirectory.appending(path: "llm.gguf"),
        contextParameters: .init(contextWindowSize: 1024)
    )
    
    @Binding var presentingAccount: Bool
    @State var showOnboarding = true
    
    /// OpenAI model
    @LLMSessionProvider(schema: llmOpenAISchema) var openAIModel: LLMOpenAISession
    /// Local Llama2 model
    @LLMSessionProvider(schema: llmLocalSchema) var localModel: LLMLocalSession
    
    
    var body: some View {
        NavigationStack {
            LLMChatView(
                session: $openAIModel
            )
                .navigationTitle("LLM_CHAT_VIEW_TITLE")
                .toolbar {
                    if AccountButton.shouldDisplay {
                        AccountButton(isPresented: $presentingAccount)
                    }
                    
                    if openAIModel.state == .generating {
                        ProgressView()
                    }
                }
                .sheet(isPresented: $showOnboarding) {
                    LLMOnboardingView(showOnboarding: $showOnboarding)
                }
        }
    }
}


#Preview {
    LLMInteraction(presentingAccount: .constant(true))
        .previewWith {
            LLMRunner {
                LLMLocalPlatform()
                LLMOpenAIPlatform()
            }
        }
}
