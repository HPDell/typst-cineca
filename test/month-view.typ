#import "@preview/cineca:0.1.0": *

#set page(margin: 0.5in)

#let events = (
  (datetime(year: 2024, month: 5, day: 1, hour: 9, minute: 0, second: 0), [Lecture]),
  (datetime(year: 2024, month: 5, day: 1, hour: 10, minute: 0, second: 0), [Lecture2]),
  (datetime(year: 2024, month: 5, day: 2, hour: 10, minute: 0, second: 0), [Meeting]),
  (datetime(year: 2024, month: 5, day: 10, hour: 12, minute: 0, second: 0), [Lunch]),
  (datetime(year: 2024, month: 5, day: 25, hour: 8, minute: 0, second: 0), [Train]),
)

#calendar-month(
  events,
  sunday-first: false,
  template: (
    month-head: (content) => strong(content)
  )
)

#calendar-month(
  events,
  sunday-first: true,
  rows: (2em,) * 2 + (8em,)
)
