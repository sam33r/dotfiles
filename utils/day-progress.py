#!/usr/bin/python
# -*- coding: utf-8 -*-
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import calendar
import datetime
import json
import os

_START_HOUR = 8
_END_HOUR = 17
_START_WEEKDAY = 0
_END_WEEKDAY = 4

now = datetime.datetime.now()


def progress_bar(percent):
    out = u""
    for i in range(1, 10):
        if percent >= i * 10:
            out += u"█"
        elif percent >= (((i - 1) * 10) + 5):
            out += u"▌"
        else:
            out += u"•"
    return out


def get_date_hash(month, day):
    return datetime.date(now.year, month, day).timetuple().tm_yday


def get_date_hash_from_string(datestr):
    tokens = datestr.split('/')
    if len(tokens) != 2:
        return None
    month = int(tokens[0])
    day = int(tokens[1])
    return get_date_hash(month, day)


def get_date_hashes_from_line(line):
    line = ''.join(line.split())
    dates = line.split('-')
    if len(dates) > 2 or len(dates) == 0:
        return []
    start = get_date_hash_from_string(dates[0])
    if not start:
        return []
    if len(dates) == 1:
        return [start]
    end = get_date_hash_from_string(dates[1])
    if not end:
        return []
    if end <= start:
        raise ValueError
    return list(range(start, end + 1))


def get_vacation_list():
    filepath = os.path.expanduser('~/.vacations')
    vacations = []
    with open(filepath) as fp:
        content = fp.readlines()
        for line in content:
            vacations.extend(get_date_hashes_from_line(line))
    return vacations


def gen_all_days_list():
    all_days = [0]
    valid_days = 0
    last_valid_day = 0
    vacations = get_vacation_list()
    for month in range(1, 13):
        month_days = calendar.monthrange(now.year, month)[1]
        for day in range(1, month_days + 1):
            thisdate = datetime.date(now.year, month, day)
            ydate = get_date_hash(month, day)
            if (
                thisdate.weekday() >= _START_WEEKDAY
                and thisdate.weekday() <= _END_WEEKDAY
            ) and ydate not in vacations:
                last_valid_day = ydate
                valid_days += 1
            all_days.append((last_valid_day, valid_days))
    return all_days


all_days = gen_all_days_list()

out = ""

today_minutes = 0
minutes_in_day = (_END_HOUR - _START_HOUR) * 60
is_today_valid = all_days[get_date_hash(now.month, now.day)][0] == get_date_hash(
    now.month, now.day
)
if is_today_valid:
    if now.hour >= _END_HOUR:
        today_minutes = minutes_in_day
    elif now.hour >= _START_HOUR:
        today_minutes = (now.hour - _START_HOUR) * 60 + now.minute

day_percent = 0
if is_today_valid:
    day_percent = (today_minutes / minutes_in_day) * 100.00

# # -- re-worked till here --

today_index = get_date_hash(now.month, now.day)
week_start_index = today_index - now.weekday()
week_end_index = today_index + (6 - now.weekday())

valid_days_in_week = all_days[week_end_index][1] - all_days[week_start_index - 1][1]
valid_days_in_week_till_yesterday = (
    all_days[today_index - 1][1] - all_days[week_start_index - 1][1]
)
week_percent = (
    ((valid_days_in_week_till_yesterday * minutes_in_day) + today_minutes)
    / (valid_days_in_week * minutes_in_day)
) * 100.00

month_start_index = today_index - now.day + 1
days_in_month = calendar.monthrange(now.year, now.month)[1]
month_end_index = today_index + (days_in_month - now.day)
valid_days_in_month = all_days[month_end_index][1] - all_days[month_start_index - 1][1]
valid_days_in_month_till_yesterday = (
    all_days[today_index - 1][1] - all_days[month_start_index - 1][1]
)
month_percent = (
    (valid_days_in_month_till_yesterday * minutes_in_day + today_minutes)
    / (valid_days_in_month * minutes_in_day)
) * 100.00

valid_days_in_year = all_days[-1][1]
valid_days_in_year_till_yesterday = all_days[today_index - 1][1]
year_percent = (
    ((valid_days_in_year_till_yesterday * minutes_in_day) + today_minutes)
    / (valid_days_in_year * minutes_in_day)
) * 100.00

out = u"Day %03.2f%% " % day_percent
out += progress_bar(day_percent)
out += u"  Week %03.2f%% " % week_percent
out += progress_bar(week_percent)
out += u"  Month %03.2f%% " % month_percent
out += progress_bar(month_percent)
out += u"  Year %03.2f%% " % year_percent
out += progress_bar(year_percent)

print(out.encode("utf-8"), end=u"")
