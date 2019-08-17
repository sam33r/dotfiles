#!/usr/bin/python
# -*- coding: utf-8 -*-
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import calendar
import datetime

_START_HOUR = 8
_END_HOUR = 17
_START_WEEKDAY = 0
_END_WEEKDAY = 5


def progress_bar(percent):
  out = u''
  for i in range(1, 10):
    if percent >= i * 10:
      out += u'█'
    else:
      out += u'•'
  return out


out = ''
now = datetime.datetime.now()
today_hours = now.hour - _START_HOUR
if now.hour > _END_HOUR:
  today_hours = _END_HOUR - _START_HOUR
if now.weekday() > _END_WEEKDAY:
  today_hours = 0

day_percent = (((now.hour - _START_HOUR) * 60 + now.minute) /
               ((_END_HOUR - _START_HOUR) * 60)) * 100
if day_percent > 100:
  day_percent = 100

minutes_in_day = (_END_HOUR - _START_HOUR) * 60
days_in_week = _END_WEEKDAY - _START_WEEKDAY
minutes_in_week = minutes_in_day * days_in_week
now_minutes_in_week = (((now.weekday() - _START_WEEKDAY) * (minutes_in_day)) +
                       (today_hours * 60))
week_percent = (now_minutes_in_week / minutes_in_week) * 100
if week_percent > 100:
  week_percent = 100

# TODO: This is inaccurate as it's not accounting for weekends.
days_in_month = calendar.monthrange(now.year, now.month)[1]
minutes_in_month = minutes_in_day * days_in_month
now_minutes_in_month = (((now.day - 1) * minutes_in_day) + (today_hours * 60))
month_percent = ((now_minutes_in_month / minutes_in_month) * 100)
if month_percent > 100:
  month_percent = 100

# TODO: This is inaccurate as it's not accounting for weekends.
day_of_year = now.timetuple().tm_yday
year_percent = (day_of_year / 365) * 100
if year_percent > 100:
  year_percent = 100

out = (u'Day %d%% ' % day_percent)
out += progress_bar(day_percent)
out += (u'  Week %d%% ' % week_percent)
out += progress_bar(week_percent)
out += (u'  Month %d%% ' % month_percent)
out += progress_bar(month_percent)
out += (u'  Year %d%% ' % year_percent)
out += progress_bar(year_percent)

print(out.encode('utf-8'), end=u'')
