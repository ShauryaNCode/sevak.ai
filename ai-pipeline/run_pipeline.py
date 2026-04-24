"""CLI runner for the SevakAI AI pipeline."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from pipeline import TriagePipeline


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Run SevakAI triage on a single message.")
    parser.add_argument("--source", default="WHATSAPP", choices=["WHATSAPP", "SMS", "VOICE_TRANSCRIPT"])
    parser.add_argument("--body", required=True, help="The raw inbound message text.")
    parser.add_argument("--sender", default=None, help="Optional sender phone number.")
    parser.add_argument("--message-id", default=None, help="Optional provider message id.")
    parser.add_argument(
        "--connectivity",
        default="auto",
        choices=["auto", "online", "offline"],
        help="Force routing behavior for demos.",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    connectivity_available = None
    if args.connectivity == "online":
        connectivity_available = True
    elif args.connectivity == "offline":
        connectivity_available = False

    pipeline = TriagePipeline()
    result = pipeline.process_text(
        body=args.body,
        source=args.source,
        sender_phone=args.sender,
        provider_message_id=args.message_id,
        connectivity_available=connectivity_available,
    )
    print(result.to_json())


if __name__ == "__main__":
    main()
