#import "/util/utils.typ": *

// Make a calendar with events.
#let calendar(
  // Event list.
  // Each element is a four-element array:
  //
  // - Index of day. Start from 0.
  // - Float-style start time.
  // - Float-style end time.
  // - Event body. Can be anything. Passed to the template.body to show more details.
  //
  // Float style time: a number representing 24-hour time. The integer part represents the hour. The fractional part represents the minute.
  events,
  // Then range of hours, affacting the range of the calendar.
  hour-range: (8, 20),
  // Height of per minute. Each minute occupys a row. This number is to control the height of each row.
  minute-height: 0.8pt,
  // Templates for headers, times, or events. It takes a dictionary of the following entries: `header`, `time`, and `event`.
  template: (:),
  // A stroke style to control the style of the default stroke, or a function taking two parameters `(x, y)` to control the stroke. The first row is the dates, and the first column is the times.
  stroke: none
) = {
  let items = events-to-calendar-items(events, hour-range.at(0))
  let days = items.keys().len()
  let hours = hour-range.at(1) - hour-range.at(0)
  let style = (
    header: default-header-style,
    time: default-time-style,
    event: default-item-style,
    ..template
  )
  let minutes-offset = hour-range.at(0) * 60
  let stroke-shape = if type(stroke) == "stroke" { stroke } else { 0.1pt + black }
  let stroke-rule = if type(stroke) == "function" { stroke } else { (x, y) => (
    right: if y < (hours * 60 + 1) { stroke-shape } else { 0pt },
    top: if x > 0 { if y < 1 { stroke-shape } else if calc.fract((y - 1) / 60) == 0 { stroke-shape } else { 0pt } }
  ) }
  grid(
    columns:(auto,) + (1fr,)*days,
    rows: (auto, ) + (minute-height,) * hours * 60 + (8pt,),
    fill: white,
    stroke: stroke-rule,
    [], ..array.range(days).map(d => (style.header)(d)),
    ..array.range(hours * 60 + 1).map(y => {
      array.range(days + 1).map(x => {
        if x == 0 {
          if calc.fract(y / 60) == 0 {
            let hour = calc.trunc(y / 60) + hour-range.at(0)
            let t = datetime(hour: hour, minute: 0, second: 0)
            (style.time)(t)
          } else []
        } else {
          if items.keys().contains(str(x)) {
            if items.at(str(x)).keys().contains(str(y)) {
              let (last, body) = items.at(str(x)).at(str(y))
              show: block.with(inset: (x: 2pt, y: 0pt), width: 100%)
              place({
                block(
                  width: 100%, 
                  height: (last) * minute-height,
                  {
                    (style.event)(..(minutes-to-datetime(y + minutes-offset), body))
                  }
                )
              })
            }
          }
        }
      })
    }).flatten()
  )
}

// Make a month view of a calendar optionally with events
#let calendar-month-summary(
  // Event list
  event: (),
  // Show (true) or hide (false) the title
  show-title: true,
  // Title above the month view --- if none and show-title is true display the range of dates
  title: none,
  // First day displayed in the month view
  date-from: datetime.today(),
  // Last day displayed in the month view
  date-to: none,
  ..args
) = {
  if date-to == none {
    // If we have no date-to we show the rest of the month
    for i in range(31) {
      date-to = date-from + duration(days: i)
      if date-to.month() != date-from.month() {
        date-to = date-from + duration(days: i - 1)
        break
      }
    }
    // TODO(Discuss): Alternatively we could just display the next 31 days?
    //date-to = date-from + duration(days: 31)
  }
  else {
    // Check if date-from and date-to have been switched
    if date-from > date-to {
      let exchange = date-to
      date-to = date-from
      date-from = exchange
    }
  }
  // Get all dates between date-from and date-to
  let dates = ()
  for i in range(calc.floor((date-to - date-from).days())+1) {
    dates.push(date-from+duration(days: i))
  }
  // Get the weekdays of the dates
  let nweek = dates.map(it => it.weekday()).filter(it => it == 1).len()
  if date-from.weekday() > 1 {
    nweek = nweek + 1
  }
  // Map the dates and weekdays
  let week-day-map = ()
  for (i, item) in dates.enumerate() {
    if i == 0 or item.weekday() == 1 {
      week-day-map.push(())
    }
    week-day-map.last().push(item)
  }
  stack(
    dir: ttb,
    grid(
      columns: (1.5em,) * 7,
      rows: (1.1em,) * (nweek + 1),
      align: center + horizon,
      ..args,
      if show-title {
        if title == none {
          grid.cell(colspan: 7)[#date-from.display() -- #date-to.display()]
        }
        else {
          grid.cell(colspan: 7)[#title]
        }
      },
      [Mo], [Tu], [We], [Th], [Fr], [Sa], [Su],
      ..week-day-map.map(week => {
      (
        range(1, week.first().weekday()).map(it => []),
        week.map(day => {
          let day-str = day.display("[year]-[month]-[day]")
          if event.len()>0 and day-str in event.keys() {
            let params = event.at(day-str)
            let (shape, args) = params
            show: circle.with(..args)
            day.display("[day padding:none]")
          } else {
            day.display("[day padding:none]")
          }
        })
      ).join()
      }).flatten()
    )
  )
}

#let calendar-month(
  events,
  template: (:),
  sunday-first: false,
  ..args
) = {
  events = events.sorted(key: ((x, _)) => int(x.display("[year][month][day][hour][minute][second]")))
  let style = (
    day-body: default-month-day,
    day-head: default-month-day-head,
    month-head: default-month-head,
    ..template
  )
  let yearmonths = events.map(it => (it.at(0).year(), it.at(0).month())).dedup()
  let event-group = events.map(it => it.at(0).display("[year]-[month]"))
  for (year, month) in yearmonths {
    let first-day = datetime(year: year, month: month, day: 1)
    let group-id = first-day.display("[year]-[month]")
    let days = get-month-days(month, year)
    let day-range = (first-day, first-day + duration(days: days - 1))
    let month-events = event-group.enumerate().filter(((i, it)) => it == group-id).map(((i, it)) => events.at(i))
    default-month-view(
      month-events,
      day-range,
      sunday-first: sunday-first,
      style-day-body: style.at("day-body"),
      style-day-head: style.at("day-head"),
      style-month-head: style.at("month-head"),
      ..args
    )
  }
}
