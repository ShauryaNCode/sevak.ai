"""Run a local benchmark over sample triage messages."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path


PIPELINE_ROOT = Path(__file__).resolve().parents[2]
if str(PIPELINE_ROOT) not in sys.path:
    sys.path.insert(0, str(PIPELINE_ROOT))

from evaluation.metrics.metrics_reporter import MetricsReporter
from pipeline import TriagePipeline


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Benchmark the SevakAI AI pipeline.")
    parser.add_argument(
        "--dataset",
        default=str(PIPELINE_ROOT / "evaluation" / "datasets" / "sample_messages.jsonl"),
        help="Path to a JSONL benchmark dataset.",
    )
    parser.add_argument("--model", default="auto", help="Reserved label for reporting.")
    parser.add_argument("--prompt-version", default="v1", help="Reserved label for reporting.")
    parser.add_argument(
        "--connectivity",
        default="online",
        choices=["online", "offline"],
        help="Run benchmark in full or offline mode.",
    )
    parser.add_argument("--min-intent-f1", type=float, default=0.75)
    return parser.parse_args()


def load_dataset(path: Path) -> list[dict[str, object]]:
    rows: list[dict[str, object]] = []
    with path.open("r", encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if stripped:
                rows.append(json.loads(stripped))
    return rows


def main() -> None:
    args = parse_args()
    dataset_path = Path(args.dataset)
    pipeline = TriagePipeline()
    metrics = MetricsReporter()
    rows = load_dataset(dataset_path)

    actual_intents: list[str] = []
    predicted_intents: list[str] = []
    actual_priorities: list[int] = []
    predicted_priorities: list[int] = []
    actual_needs: list[set[str]] = []
    predicted_needs: list[set[str]] = []
    actual_locations: list[str | None] = []
    predicted_locations: list[str | None] = []
    routes: list[str] = []

    for row in rows:
        expected = row["expected"]
        result = pipeline.process_text(
            body=str(row["body"]),
            source=str(row.get("source", "WHATSAPP")),
            sender_phone=str(row.get("sender_phone")) if row.get("sender_phone") else None,
            connectivity_available=args.connectivity == "online",
        )

        actual_intents.append(str(expected["intent"]))
        predicted_intents.append(result.intent.value)
        actual_priorities.append(int(expected["priority"]))
        predicted_priorities.append(result.priority)
        actual_needs.append(set(expected.get("needs", [])))
        predicted_needs.append(set(result.needs))
        actual_locations.append(expected.get("location_contains"))
        predicted_locations.append(result.location_raw)
        routes.append(result.route.value)

    intent_metrics = metrics.classification_prf(actual_intents, predicted_intents)
    priority_mae = metrics.mean_absolute_error(actual_priorities, predicted_priorities)
    needs_metrics = metrics.multilabel_prf(actual_needs, predicted_needs)
    location_metrics = metrics.location_prf(actual_locations, predicted_locations)
    route_distribution = metrics.route_distribution(routes)

    print(f"Dataset: {dataset_path}")
    print(f"Model Label: {args.model}")
    print(f"Prompt Version: {args.prompt_version}")
    print(
        "Intent Classification: "
        f"P={intent_metrics['precision']:.2f} "
        f"R={intent_metrics['recall']:.2f} "
        f"F1={intent_metrics['f1']:.2f}"
    )
    print(f"Priority Scoring: MAE={priority_mae:.2f}")
    print(
        "Needs Extraction: "
        f"P={needs_metrics['precision']:.2f} "
        f"R={needs_metrics['recall']:.2f} "
        f"F1={needs_metrics['f1']:.2f}"
    )
    print(
        "Location Extraction: "
        f"P={location_metrics['precision']:.2f} "
        f"R={location_metrics['recall']:.2f} "
        f"F1={location_metrics['f1']:.2f}"
    )
    print(f"Route Distribution: {route_distribution}")

    if intent_metrics["f1"] < args.min_intent_f1:
        raise SystemExit(
            f"Intent F1 {intent_metrics['f1']:.2f} is below the required gate of {args.min_intent_f1:.2f}."
        )


if __name__ == "__main__":
    main()
