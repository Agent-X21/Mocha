//
//  CoffeeJarCard.swift
//  Mocha
//
//  Created by Zane Duncan on 9/4/25.
//


//
//  CoffeeJarCard.swift
//  Mocha
//
//  A card that displays a coffee jar's name, balance, and fill level.
//

import SwiftUI

struct CoffeeJarCard: View {
    let jar: CoffeeJar
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 14) {

                // ☕ Jar icon with liquid fill
                ZStack {
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 50))
                        .foregroundColor(jar.category.color)

                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                LinearGradient(
                                    colors: [jar.category.color.opacity(0.85), jar.category.color.opacity(0.4)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 42, height: max(8, CGFloat(jar.fillPercentage.doubleValue) * 40))
                            .animation(.easeInOut(duration: 0.6), value: jar.fillPercentage.doubleValue)
                    }
                    .frame(width: 50, height: 50)
                }

                VStack(spacing: 6) {
                    Text(jar.name)
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.primary)

                    Text(jar.balance, format: .currency(code: "USD"))
                        .font(.title2.weight(.bold))
                        .foregroundColor(.primary)

                    Text("\(Int(jar.fillPercentage.doubleValue * 100))% full")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(18)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    CoffeeJarCard(
        jar: CoffeeJar(name: "Emergency", category: .emergency, balance: 120)
    ) {}
}

extension Decimal {
    var doubleValue: Double { NSDecimalNumber(decimal: self).doubleValue }
}
