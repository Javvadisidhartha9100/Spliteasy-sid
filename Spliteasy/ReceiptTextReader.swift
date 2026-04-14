//
//  ReceiptTextReader.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 4/14/26.
//

//
//  ReceiptTextReader.swift
//  Spliteasy
//

import Foundation
import Vision
import UIKit

struct ReceiptScanResult {
    let recognizedText: String
    let detectedAmount: Double?
}

final class ReceiptTextReader {
    static let shared = ReceiptTextReader()

    private init() {}

    func scanReceipt(
        image: UIImage,
        completion: @escaping (Result<ReceiptScanResult, Error>) -> Void
    ) {
        guard let cgImage = image.cgImage else {
            completion(.failure(NSError(
                domain: "ReceiptTextReader",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Unable to read the selected image."]
            )))
            return
        }

        let request = VNRecognizeTextRequest { request, error in
            if let error {
                completion(.failure(error))
                return
            }

            let observations = request.results as? [VNRecognizedTextObservation] ?? []

            let lines: [String] = observations.compactMap {
                $0.topCandidates(1).first?.string
            }

            let fullText = lines.joined(separator: "\n")
            let detectedAmount = Self.extractLikelyTotal(from: lines)

            completion(.success(
                ReceiptScanResult(
                    recognizedText: fullText,
                    detectedAmount: detectedAmount
                )
            ))
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                completion(.failure(error))
            }
        }
    }

    private static func extractLikelyTotal(from lines: [String]) -> Double? {
        let lowered = lines.map { $0.lowercased() }

        let strongKeywords = [
            "grand total",
            "amount due",
            "total due",
            "balance due",
            "total"
        ]

        let ignoreKeywords = [
            "subtotal",
            "sub total",
            "tax",
            "tip",
            "discount",
            "change",
            "cash"
        ]

        for keyword in strongKeywords {
            for line in lowered {
                guard line.contains(keyword) else { continue }
                guard !ignoreKeywords.contains(where: { line.contains($0) && $0 != "total" }) else { continue }

                if let amount = extractLargestCurrencyValue(from: line) {
                    return amount
                }
            }
        }

        let allAmounts = lowered.compactMap { extractLargestCurrencyValue(from: $0) }
        return allAmounts.max()
    }

    private static func extractLargestCurrencyValue(from text: String) -> Double? {
        let pattern = #"(\$?\s*\d+[.,]\d{2})"#

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }

        let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)

        let matches = regex.matches(in: text, options: [], range: nsRange)

        let values: [Double] = matches.compactMap { match in
            guard let range = Range(match.range(at: 1), in: text) else { return nil }

            let raw = String(text[range])
                .replacingOccurrences(of: "$", with: "")
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: ",", with: ".")

            return Double(raw)
        }

        return values.max()
    }
}
