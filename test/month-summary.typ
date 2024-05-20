#import "@preview/cineca:0.1.0": *

#calendar-month-summary(
   date-from: datetime(year: 2024, month: 12, day: 24),
   date-to: datetime(year: 2025, month: 1, day: 24),
   stroke: 1pt,
)

#calendar-month-summary(
  event: (
    "2024-05-21": (circle, (stroke: color.green, inset: 2pt)),
    "2024-05-22": (circle, (stroke: color.green, inset: 2pt)),
    "2024-05-27": (circle, (stroke: color.green, inset: 2pt)),
    "2024-05-28": (circle, (stroke: color.blue, inset: 2pt)),
    "2024-05-29": (circle, (stroke: color.blue, inset: 2pt)),
    "2024-06-03": (circle, (stroke: color.blue, inset: 2pt)),
    "2024-06-04": (circle, (stroke: color.yellow, inset: 2pt)),
    "2024-06-05": (circle, (stroke: color.yellow, inset: 2pt)),
    "2024-06-10": (circle, (stroke: color.red, inset: 2pt)),
  ),
  date-from: datetime(year: 2024, month: 5, day: 20),
  date-to: datetime(year: 2024, month: 6, day: 30),
)