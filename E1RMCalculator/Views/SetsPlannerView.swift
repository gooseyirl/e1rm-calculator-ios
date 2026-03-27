import SwiftUI

private struct BackoffConfig: Identifiable {
    let id: Int
    var numSets: String = "1"
    var reps: String = ""
    var type: String = "RPE"
    var rpe: Double = 7.0
    var percentValue: String = "10"
    var percentIsIncrease: Bool = false
    var specificWeight: String = ""
}

private struct PlannedSet {
    let reps: Int
    let weight: Double
    let rpe: Double?
}

struct SetsPlannerView: View {
    @EnvironmentObject var settings: AppSettings

    @State private var topSetWeight: String = ""
    @State private var topSetReps: String = ""
    @State private var topSetRpe: Double = 8.0
    @State private var backoffConfigs: [BackoffConfig] = [BackoffConfig(id: 0)]
    @State private var plannedSets: [PlannedSet]? = nil
    @State private var copied: Bool = false
    @State private var nextId: Int = 1
    @State private var generateCount: Int = 0

    private let rpeValues = OneRepMaxCalculator.getSupportedRpeValues()

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sets Planner")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.blue)
                        Text("Plan your sets")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 32)

                    // First Set
                    Text("First Set")
                        .font(.system(size: 18, weight: .bold))
                        .padding(.bottom, 12)

                    TextField("Weight (\(settings.units))", text: $topSetWeight)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .padding(.bottom, 12)

                    HStack(spacing: 12) {
                        TextField("Reps", text: $topSetReps)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)

                        Picker("RPE", selection: $topSetRpe) {
                            ForEach(rpeValues.reversed(), id: \.self) { rpe in
                                Text(String(format: "RPE %.1f", rpe)).tag(rpe)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    }
                    .padding(.bottom, 28)

                    // Additional Sets
                    Text("Additional Sets")
                        .font(.system(size: 18, weight: .bold))
                        .padding(.bottom, 8)

                    ForEach($backoffConfigs) { $config in
                        BackoffConfigCard(
                            config: $config,
                            index: backoffConfigs.firstIndex(where: { $0.id == config.id }) ?? 0,
                            canRemove: backoffConfigs.count > 1,
                            units: settings.units,
                            rpeValues: rpeValues,
                            onRemove: {
                                backoffConfigs.removeAll { $0.id == config.id }
                            }
                        )
                        .padding(.bottom, 12)
                    }

                    Button(action: {
                        let last = backoffConfigs.last ?? BackoffConfig(id: 0)
                        backoffConfigs.append(BackoffConfig(id: nextId, numSets: last.numSets, reps: last.reps))
                        nextId += 1
                    }) {
                        Text("+ Add Set")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color(UIColor.systemBackground))
                            .foregroundColor(.blue)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                    }
                    .padding(.bottom, 8)

                    // Generate Button
                    Button(action: generateSets) {
                        Text("Generate Sets")
                            .font(.system(size: 18, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canGenerate ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(!canGenerate)
                    .padding(.bottom, 24)

                    // Results
                    if let sets = plannedSets {
                        let grouped = groupPlannedSets(sets)

                        VStack(spacing: 0) {
                            ForEach(Array(grouped.enumerated()), id: \.offset) { index, item in
                                let (count, set) = item
                                HStack {
                                    Text(index == 0 ? "Set 1" : "Set \(index + 1)")
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    Text("\(count)×\(set.reps)")
                                        .font(.system(size: 15, weight: .bold))
                                        .frame(maxWidth: .infinity, alignment: .center)

                                    Text("\(WeightRounder.format(set.weight, rounding: settings.rounding)) \(settings.units)")
                                        .font(.system(size: 15, weight: index == 0 ? .bold : .regular))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)

                                if index < grouped.count - 1 {
                                    Divider().padding(.horizontal, 16)
                                }
                            }
                        }
                        .background(Color.blue.opacity(0.08))
                        .cornerRadius(12)
                        .padding(.bottom, 12)

                        Button(action: {
                            UIPasteboard.general.string = buildCopyText(sets)
                            copied = true
                        }) {
                            Text(copied ? "✓ Copied!" : "Copy to Clipboard")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(copied ? Color(UIColor.systemGreen) : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .id("bottom")
                        .padding(.bottom, 32)
                    }
                }
                .padding(24)
                .onChange(of: generateCount) {
                    withAnimation {
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
            }
        }
        .navigationTitle("Sets Planner")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    private var canGenerate: Bool {
        !topSetWeight.isEmpty && !topSetReps.isEmpty
    }

    private func generateSets() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        guard let weight = Double(topSetWeight), let reps = Int(topSetReps) else { return }
        let oneRepMax = OneRepMaxCalculator.calculateOneRepMax(weight: weight, reps: reps, rpe: topSetRpe)

        var sets: [PlannedSet] = [PlannedSet(reps: reps, weight: weight, rpe: topSetRpe)]

        for config in backoffConfigs {
            guard let numSets = Int(config.numSets).map({ max(1, min(20, $0)) }) else { continue }
            let bReps = Int(config.reps) ?? reps

            switch config.type {
            case "RPE":
                guard let e1rm = oneRepMax,
                      let bWeight = OneRepMaxCalculator.calculateWeightForReps(oneRepMax: e1rm, reps: bReps, rpe: config.rpe)
                else { continue }
                for _ in 0..<numSets { sets.append(PlannedSet(reps: bReps, weight: bWeight, rpe: config.rpe)) }

            case "%":
                guard let pct = Int(config.percentValue).map({ max(1, min(99, $0)) }) else { continue }
                let factor = config.percentIsIncrease ? 1.0 + Double(pct) / 100.0 : 1.0 - Double(pct) / 100.0
                let bWeight = sets.last!.weight * factor
                for _ in 0..<numSets { sets.append(PlannedSet(reps: bReps, weight: bWeight, rpe: nil)) }

            case "Weight":
                guard let bWeight = Double(config.specificWeight) else { continue }
                for _ in 0..<numSets { sets.append(PlannedSet(reps: bReps, weight: bWeight, rpe: nil)) }

            default: break
            }
        }

        plannedSets = sets
        copied = false
        generateCount += 1
    }

    private func groupPlannedSets(_ sets: [PlannedSet]) -> [(Int, PlannedSet)] {
        guard !sets.isEmpty else { return [] }
        var result: [(Int, PlannedSet)] = []
        var count = 1
        for i in 1..<sets.count {
            let curr = sets[i]
            let prev = sets[i - 1]
            if curr.reps == prev.reps &&
               WeightRounder.round(curr.weight, rounding: settings.rounding) == WeightRounder.round(prev.weight, rounding: settings.rounding) {
                count += 1
            } else {
                result.append((count, prev))
                count = 1
            }
        }
        result.append((count, sets.last!))
        return result
    }

    private func buildCopyText(_ sets: [PlannedSet]) -> String {
        groupPlannedSets(sets).map { (count, set) in
            "\(count) x \(set.reps) @ \(WeightRounder.format(set.weight, rounding: settings.rounding))\(settings.units)"
        }.joined(separator: "\n")
    }
}

private struct BackoffConfigCard: View {
    @Binding var config: BackoffConfig
    let index: Int
    let canRemove: Bool
    let units: String
    let rpeValues: [Double]
    let onRemove: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Set \(index + 2)")
                    .font(.system(size: 15, weight: .semibold))
                Spacer()
                if canRemove {
                    Button("Remove", action: onRemove)
                        .font(.system(size: 13))
                        .foregroundColor(.red)
                }
            }

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Sets").font(.caption).foregroundColor(.secondary)
                    TextField("Sets", text: $config.numSets)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Reps (blank = same)").font(.caption).foregroundColor(.secondary)
                    TextField("Reps", text: $config.reps)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                }
            }

            // Type selector
            HStack(spacing: 8) {
                ForEach(["RPE", "%", "Weight"], id: \.self) { type in
                    let chipLabel: String = {
                        if type == "%" && config.type == "%" {
                            return config.percentIsIncrease ? "% +" : "% -"
                        } else if type == "%" {
                            return "% -"
                        }
                        return type
                    }()
                    let isSelected = config.type == type

                    Button(action: {
                        if config.type == "%" && type == "%" {
                            config.percentIsIncrease.toggle()
                        } else {
                            config.type = type
                            config.percentIsIncrease = false
                        }
                    }) {
                        Text(chipLabel)
                            .font(.system(size: 13))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity)
                            .background(isSelected ? Color.blue : Color(UIColor.systemGray5))
                            .foregroundColor(isSelected ? .white : .primary)
                            .cornerRadius(16)
                    }
                }
            }

            // Type-specific input
            switch config.type {
            case "RPE":
                Picker("RPE", selection: $config.rpe) {
                    ForEach(rpeValues.reversed(), id: \.self) { rpe in
                        Text(String(format: "RPE %.1f", rpe)).tag(rpe)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 6)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)

            case "%":
                TextField(config.percentIsIncrease ? "% Increase per Set" : "% Reduction per Set", text: $config.percentValue)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)

            case "Weight":
                TextField("Specific Weight (\(units))", text: $config.specificWeight)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)

            default: EmptyView()
            }
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        SetsPlannerView()
            .environmentObject(AppSettings())
    }
}
