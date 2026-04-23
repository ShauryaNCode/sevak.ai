"""Geospatial helpers."""

from __future__ import annotations

import math


def haversine_distance_km(
    lat1: float | None,
    lng1: float | None,
    lat2: float | None,
    lng2: float | None,
) -> float | None:
    """Return distance in kilometers, or None when coordinates are incomplete."""

    if None in (lat1, lng1, lat2, lng2):
        return None

    radius_km = 6371.0
    d_lat = math.radians(lat2 - lat1)
    d_lng = math.radians(lng2 - lng1)
    start_lat = math.radians(lat1)
    end_lat = math.radians(lat2)

    a = (
        math.sin(d_lat / 2) ** 2
        + math.cos(start_lat) * math.cos(end_lat) * math.sin(d_lng / 2) ** 2
    )
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    return radius_km * c
