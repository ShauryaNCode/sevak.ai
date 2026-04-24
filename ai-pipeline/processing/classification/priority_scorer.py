"""Priority scoring for need urgency."""

from __future__ import annotations

from models.contracts import Intent


class PriorityScorer:
    """Score severity on a 1-5 scale."""

    URGENT_KEYWORDS = {
        "urgent",
        "immediately",
        "asap",
        "emergency",
        "critical",
        "now",
    }
    LIFE_THREAT_KEYWORDS = {
        "rescue",
        "trapped",
        "drowning",
        "injured",
        "bleeding",
        "ambulance",
        "collapsed",
        "fire",
    }

    def score(
        self,
        text: str,
        intent: str,
        disaster_type: str,
        needs: list[str],
        affected_count: int | None,
        vulnerable_groups: list[str],
    ) -> tuple[int, list[str]]:
        lowered = (text or "").lower()
        reasons: list[str] = []

        if intent == Intent.NOISE.value:
            return (1, ["noise_message"])

        score = 2 if intent == Intent.NEED.value else 1
        if intent == Intent.OFFER.value:
            score = 2
            reasons.append("offer_signal")
        else:
            reasons.append("need_signal")

        if intent == Intent.NEED.value and needs:
            score += 1
            reasons.append("actionable_need_detected")

        if any(keyword in lowered for keyword in self.URGENT_KEYWORDS):
            score += 1
            reasons.append("explicit_urgency")

        if any(keyword in lowered for keyword in self.LIFE_THREAT_KEYWORDS):
            score += 1
            reasons.append("life_threat_keywords")

        if disaster_type in {"FLOOD", "FIRE", "LANDSLIDE", "CYCLONE"}:
            score += 1
            reasons.append(f"disaster:{disaster_type.lower()}")

        if intent == Intent.NEED.value:
            if affected_count is not None and affected_count >= 10:
                score += 1
                reasons.append("multiple_people_affected")

            if affected_count is not None and affected_count >= 50:
                score += 1
                reasons.append("mass_impact")

            if vulnerable_groups:
                score += 1
                reasons.append("vulnerable_groups")

            if {"RESCUE", "MEDICAL"} & set(needs):
                score += 1
                reasons.append("critical_need_type")

            if {"WATER", "FOOD", "SHELTER"} <= set(needs):
                score += 1
                reasons.append("compound_basic_needs")

        upper_bound = 4 if intent == Intent.OFFER.value else 5
        return (max(1, min(upper_bound, score)), reasons)
