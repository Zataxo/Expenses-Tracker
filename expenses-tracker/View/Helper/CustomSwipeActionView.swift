//
//  CustomSwipeActionView.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 09/01/1448 AH.
//

import SwiftUI

struct SwipeableRow<Content: View, ActionView: View>: View {
    var content: Content
    var actionView: ActionView
    var actionWidth: CGFloat
    var onAction: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var isSwiped = false
    
    init(
        actionWidth: CGFloat = 80,
        onAction: @escaping () -> Void,
        @ViewBuilder content: () -> Content,
        @ViewBuilder actionView: () -> ActionView
    ) {
        self.actionWidth = actionWidth
        self.onAction = onAction
        self.content = content()
        self.actionView = actionView()
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Background Action Layer (Revealed during swipe)
            actionView
                .frame(width: actionWidth)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        offset = 0
                        isSwiped = false
                    }
                    // Trigger haptic feedback on execution
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    onAction()
                }
            
            // Foreground Content Layer
            content
//                .background(Color(.systemBackground)) // Block visual overlap
                .offset(x: offset)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let translation = value.translation.width
                            
                            // Check if swiping from left to right (leading edge swipe)
                            if isSwiped {
                                // If already open, let the user close it
                                let newOffset = actionWidth + translation
                                offset = max(0, min(newOffset, actionWidth + 30))
                            } else {
                                // If closed, only allow rightward swipe up to width + rubber-banding
                                offset = max(0, min(translation, actionWidth + 30))
                            }
                        }
                        .onEnded { value in
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                // Threshold to snap open is 50% of the action width
                                if offset > (actionWidth * 0.5) {
                                    offset = actionWidth
                                    if !isSwiped {
                                        // Light feedback when snapping open
                                        let generator = UIImpactFeedbackGenerator(style: .light)
                                        generator.impactOccurred()
                                    }
                                    isSwiped = true
                                } else {
                                    offset = 0
                                    isSwiped = false
                                }
                            }
                        }
                )
        }
    }
}


