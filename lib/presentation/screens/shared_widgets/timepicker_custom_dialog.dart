import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/utils/times.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeType initialTimeType;
  final void Function(TimeRange value) onTimeChanged;
  final bool allowDay;

  const CustomTimePicker({
    Key? key,
    this.initialTimeType = TimeType.day,
    this.allowDay = true,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

enum TimeType {
  day,
  week,
  month,
  year,
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late TimeType _currentTimeType;
  late TimeRange _currentTime;

  List<Map<String, dynamic>> _timeTypeList(bool allowDay) {
    final day = allowDay ? <Map<String, dynamic>>[{ "value": TimeType.day, "name": "Ngày"}] : <Map<String, dynamic>>[];
    return day +
    [
      {
        "value": TimeType.week,
        "name": "Tuần",
      },
      {
        "value": TimeType.month,
        "name": "Tháng",
      },
      {
        "value": TimeType.year,
        "name": "Năm",
      },
    ];
  }

  String _getTimeString(){
    switch(_currentTimeType) {
      case TimeType.day: {
        return DateFormat.yMd().format(_currentTime.start);
      }
      case TimeType.week: {
        final formatter = DateFormat(DateFormat.ABBR_MONTH_DAY);
        return "${formatter.format(_currentTime.start)} ~ ${formatter.format(_currentTime.end)}";
      }
      case TimeType.month: {
        return DateFormat.yM().format(_currentTime.start);
      }
      case TimeType.year: {
        return "${_currentTime.start.year}";
      }
    }
  }

  void _setNewType() {
    _currentTime = switch(_currentTimeType) {
      TimeType.day => getRangeOfDay(),
      TimeType.week => getRangeOfTheWeek(),
      TimeType.month => getRangeOfTheMonth(),
      TimeType.year => getRangeOfTheYear(),
    };
    widget.onTimeChanged(_currentTime);
  }
  
  void _toPrevious() {
    _currentTime = switch(_currentTimeType) {
      TimeType.day => getPreviousDayRange(range: _currentTime),
      TimeType.week => getPreviousWeekRangeByRange(range: _currentTime),
      TimeType.month => getPreviousMonthRangeByRange(range: _currentTime),
      TimeType.year => getPreviousYearRange(range: _currentTime),
    };
    widget.onTimeChanged(_currentTime);
  }

  void _toNext() {
    setState(() {
      _currentTime = switch(_currentTimeType) {
        TimeType.day => getNextDayRange(range: _currentTime),
        TimeType.week => getNextWeekRangeByRange(range: _currentTime),
        TimeType.month => getNextMonthRangeByRange(range: _currentTime),
        TimeType.year => getNextYearRange(range: _currentTime),
      };
      widget.onTimeChanged(_currentTime);
    });
  }

  @override
  void initState() {
    _currentTimeType = widget.initialTimeType;
    _currentTime = getRangeOfDay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final timeTypeList = _timeTypeList(widget.allowDay);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        children: [
          // Time type menu
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              timeTypeList.length,
              (index) {
                final thisType = timeTypeList[index];
                return GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    width: 50,
                    height: 25,
                    margin: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: thisType["value"] == _currentTimeType
                              ? Colors.lightBlue.shade600 
                              : Colors.white,
                    ),
                    child: Text(
                      thisType["name"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: thisType["value"] == _currentTimeType
                                ? Colors.white 
                                : Colors.black87,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _currentTimeType = thisType["value"];
                      _setNewType();
                    });
                  },
                );
              }
            ),
          ),
          // DatePicker
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(CupertinoIcons.chevron_left),
                  onPressed: () => setState(() {
                    _toPrevious();
                  }),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  _getTimeString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(CupertinoIcons.chevron_right),
                  onPressed: () => setState(() {
                    _toNext();
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
