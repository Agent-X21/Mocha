//
//  JarsView.swift
//  Mocha
//
//  Created by Zane Duncan on 9/4/25.
//


//
//  JarsView.swift
//  Mocha
//
//  Displays all coffee jars and allows tapping or drag-and-drop for transfers.
//

import SwiftUI
import UniformTypeIdentifiers

struct JarsView: View {
    @ObservedObject var viewModel: MochaViewModel

    // Called when a jar is tapped
    var onTapJar: (CoffeeJar) -> Void

    // Drag state for drag-and-drop
    @State private var draggedJar: CoffeeJar?

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 18) {
                ForEach(viewModel.jars) { jar in
                    CoffeeJarCard(jar: jar) {
                        onTapJar(jar)
                    }
                    .onDrag {
                        draggedJar = jar
                        return NSItemProvider(object: jar.name as NSString)
                    }
                    .onDrop(of: [UTType.text], delegate: DropJarDelegate(
                        target: jar,
                        draggedJar: $draggedJar,
                        viewModel: viewModel
                    ))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - DropJarDelegate
//
// Handles dropping one jar onto another to trigger transfer
//
struct DropJarDelegate: DropDelegate {
    let target: CoffeeJar
    @Binding var draggedJar: CoffeeJar?
    let viewModel: MochaViewModel

    func performDrop(info: DropInfo) -> Bool {
        guard let fromJar = draggedJar else { return false }
        guard fromJar.id != target.id else { return false }

        viewModel.transferSourceJar = fromJar
        viewModel.transferDestinationJar = target
        viewModel.showingTransfer = true

        draggedJar = nil
        return true
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func dropExited(info: DropInfo) {
        // Optional: handle if needed
    }
}

// MARK: - Preview
#Preview {
    JarsView(viewModel: MochaViewModel()) { _ in }
}
