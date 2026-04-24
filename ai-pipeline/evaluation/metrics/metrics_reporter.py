"""Metric helpers for the SevakAI benchmark suite."""

from __future__ import annotations

from collections import Counter
from typing import Iterable


class MetricsReporter:
    """Compute simple benchmark metrics without extra dependencies."""

    def classification_prf(self, actual: list[str], predicted: list[str]) -> dict[str, float]:
        labels = sorted(set(actual) | set(predicted))
        precisions: list[float] = []
        recalls: list[float] = []
        f1_scores: list[float] = []

        for label in labels:
            tp = sum(1 for truth, pred in zip(actual, predicted) if truth == label and pred == label)
            fp = sum(1 for truth, pred in zip(actual, predicted) if truth != label and pred == label)
            fn = sum(1 for truth, pred in zip(actual, predicted) if truth == label and pred != label)
            precision = tp / (tp + fp) if tp + fp else 0.0
            recall = tp / (tp + fn) if tp + fn else 0.0
            f1 = 2 * precision * recall / (precision + recall) if precision + recall else 0.0
            precisions.append(precision)
            recalls.append(recall)
            f1_scores.append(f1)

        return {
            "precision": round(sum(precisions) / len(precisions), 2) if precisions else 0.0,
            "recall": round(sum(recalls) / len(recalls), 2) if recalls else 0.0,
            "f1": round(sum(f1_scores) / len(f1_scores), 2) if f1_scores else 0.0,
        }

    def mean_absolute_error(self, actual: list[int], predicted: list[int]) -> float:
        if not actual:
            return 0.0
        total_error = sum(abs(truth - pred) for truth, pred in zip(actual, predicted))
        return round(total_error / len(actual), 2)

    def multilabel_prf(self, actual_sets: Iterable[set[str]], predicted_sets: Iterable[set[str]]) -> dict[str, float]:
        tp = 0
        fp = 0
        fn = 0
        for actual, predicted in zip(actual_sets, predicted_sets):
            tp += len(actual & predicted)
            fp += len(predicted - actual)
            fn += len(actual - predicted)

        precision = tp / (tp + fp) if tp + fp else 0.0
        recall = tp / (tp + fn) if tp + fn else 0.0
        f1 = 2 * precision * recall / (precision + recall) if precision + recall else 0.0
        return {
            "precision": round(precision, 2),
            "recall": round(recall, 2),
            "f1": round(f1, 2),
        }

    def location_prf(self, expected: list[str | None], predicted: list[str | None]) -> dict[str, float]:
        tp = 0
        fp = 0
        fn = 0
        for expected_location, predicted_location in zip(expected, predicted):
            expected_norm = (expected_location or "").strip().lower()
            predicted_norm = (predicted_location or "").strip().lower()
            if expected_norm and predicted_norm:
                if expected_norm in predicted_norm or predicted_norm in expected_norm:
                    tp += 1
                else:
                    fp += 1
                    fn += 1
            elif expected_norm and not predicted_norm:
                fn += 1
            elif predicted_norm and not expected_norm:
                fp += 1

        precision = tp / (tp + fp) if tp + fp else 0.0
        recall = tp / (tp + fn) if tp + fn else 0.0
        f1 = 2 * precision * recall / (precision + recall) if precision + recall else 0.0
        return {
            "precision": round(precision, 2),
            "recall": round(recall, 2),
            "f1": round(f1, 2),
        }

    def route_distribution(self, routes: list[str]) -> dict[str, int]:
        return dict(Counter(routes))
