#import "@preview/cineca:0.1.0": *

// #calendar-month-summary(
//    date-from: datetime(year: 2024, month: 12, day: 24),
//    date-to: datetime(year: 2025, month: 1, day: 24),
//    stroke: 1pt,
// )
#let events = (
  (datetime(year: 2024, month: 05, day: 21), (circle, (stroke: color.green, inset: 2pt))),
  (datetime(year: 2024, month: 05, day: 22), (circle, (stroke: color.green, inset: 2pt))),
  (datetime(year: 2024, month: 05, day: 27), (circle, (stroke: color.green, inset: 2pt))),
  (datetime(year: 2024, month: 05, day: 28), (circle, (stroke: color.blue, inset: 2pt))),
  (datetime(year: 2024, month: 05, day: 29), (circle, (stroke: color.blue, inset: 2pt))),
  (datetime(year: 2024, month: 06, day: 03), (circle, (stroke: color.blue, inset: 2pt))),
  (datetime(year: 2024, month: 06, day: 04), (circle, (stroke: color.yellow, inset: 2pt))),
  (datetime(year: 2024, month: 06, day: 05), (circle, (stroke: color.yellow, inset: 2pt))),
  (datetime(year: 2024, month: 06, day: 10), (circle, (stroke: color.red, inset: 2pt))),
)

#calendar-month-summary(
  events: events
)

#calendar-month-summary(
  events: events,
  sunday-first: true
)