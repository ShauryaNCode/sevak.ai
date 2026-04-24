"""Smoke tests for the SevakAI AI pipeline."""

from __future__ import annotations

import sys
import unittest
from pathlib import Path


PIPELINE_ROOT = Path(__file__).resolve().parents[1]
if str(PIPELINE_ROOT) not in sys.path:
    sys.path.insert(0, str(PIPELINE_ROOT))

from models.contracts import ProcessingMode
from pipeline import TriagePipeline


class TriagePipelineTests(unittest.TestCase):
    def setUp(self) -> None:
        self.pipeline = TriagePipeline()

    def test_hinglish_need_message_extracts_core_entities(self) -> None:
        result = self.pipeline.process_text(
            body="Bhai 50 log phase gaye hai, khana nahi hai, 3 baache hain, paani bhar gaya near Lal Chowk urgent",
            source="WHATSAPP",
            connectivity_available=True,
        )

        self.assertEqual(result.intent.value, "NEED")
        self.assertEqual(result.disaster_type.value, "FLOOD")
        self.assertIn("FOOD", result.needs)
        self.assertIn("RESCUE", result.needs)
        self.assertEqual(result.affected_count, 50)
        self.assertIn("CHILDREN", result.vulnerable_groups)
        self.assertEqual(result.location_raw, "lal chowk")
        self.assertGreaterEqual(result.priority, 5)
        self.assertEqual(result.route.value, ProcessingMode.LOCAL_FALLBACK.value)

    def test_offline_mode_marks_pending_cloud_processing(self) -> None:
        result = self.pipeline.process_text(
            body="Need ambulance in Sangli now urgent",
            source="SMS",
            connectivity_available=False,
        )

        self.assertEqual(result.route.value, ProcessingMode.OFFLINE.value)
        self.assertTrue(result.pending_cloud_processing)
        self.assertEqual(result.metadata["offline_priority_band"], "URGENT")
        self.assertIsNone(result.location_raw)

    def test_offer_message_routes_without_backend_dependency(self) -> None:
        result = self.pipeline.process_text(
            body="We have 200 food packets available in Solapur",
            source="WHATSAPP",
            connectivity_available=True,
        )

        self.assertEqual(result.intent.value, "OFFER")
        self.assertIn("FOOD", result.needs)
        self.assertEqual(result.location_raw, "solapur")
        self.assertFalse(result.pending_cloud_processing)

    def test_duplicate_detection_flags_second_message(self) -> None:
        first = self.pipeline.process_text(
            body="Need water in Sangli urgent",
            source="SMS",
            sender_phone="+919999999999",
            connectivity_available=True,
        )
        second = self.pipeline.process_text(
            body="Need water in Sangli urgent",
            source="SMS",
            sender_phone="+919999999999",
            connectivity_available=True,
        )

        self.assertFalse(first.duplicate_suspected)
        self.assertTrue(second.duplicate_suspected)


if __name__ == "__main__":
    unittest.main()
