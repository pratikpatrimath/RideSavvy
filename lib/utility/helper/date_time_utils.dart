import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'common_helper.dart';

class DateTimeUtils {
  static String? currentDate() {
    try {
      final now = DateTime.now();
      DateFormat dateFormat = DateFormat("yyyy/MM/dd");
      return dateFormat.format(now);
    } catch (e) {
      CommonHelper.printDebugError(e, "DateTimeUtils line 14");
      return null;
    }
  }

  static String currentTime() {
    DateTime currentDateTime = DateTime.now();
    DateFormat dateFormat = DateFormat("HH:mm:ss");
    return dateFormat.format(currentDateTime);
  }

  static String? currentDateTimeYMDHMS() {
    try {
      final now = DateTime.now();
      DateFormat dateFormat = DateFormat("yyyy/MM/dd HH:mm:ss");
      return dateFormat.format(now);
    } catch (e) {
      CommonHelper.printDebugError(e, "DateTimeUtils line 25");
      return null;
    }
  }

  static String? dateTimeToString({required DateTime? dateTime}) {
    try {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd HH:mm:ss");
      return dateFormat.format(dateTime ?? DateTime.now());
    } catch (e) {
      CommonHelper.printDebugError(e, "DateTimeUtils line 14");
      return null;
    }
  }

  static DateTime? stringToDateTime({required String? string}) {
    try {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd HH:mm:ss");
      return dateFormat.parse(string!.trim());
    } catch (e) {
      return null;
    }
  }

  static DateTime? convertTo24hour({required String? string}) {
    try {
      DateFormat dateFormat = DateFormat("hh:mma");
      return dateFormat.parse(string!);
    } catch (e) {
      return null;
    }
  }

  static String? stringToDate({required String? string}) {
    try {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd");
      try {
        return dateFormat.format(dateFormat.parse(string!.trim()));
      } catch (e) {
        return dateFormat.format(DateTime.now());
      }
    } catch (e) {
      return null;
    }
  }

  static String? stringToTime({required String? string}) {
    try {
      try {
        return DateFormat.jm().format(stringToDateTime(string: string)!);
      } catch (e) {
        return DateFormat.jm().format(DateTime.now());
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String?> showDatePickerDialog({
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    DateFormat dateFormat = DateFormat(DateFormat.YEAR);
    int currentYear = int.parse(dateFormat.format(DateTime.now()));
    final DateTime? d = await showDatePicker(
      context: Get.context as BuildContext,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(currentYear - 100),
      lastDate: lastDate ?? DateTime(currentYear + 1),
    );
    if (d != null) {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd");
      return dateFormat.format(d);
    }
    return null;
  }

  static Future<String?> showDateTimePickerDialog({
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    DateFormat dateFormat = DateFormat(DateFormat.YEAR);
    int currentYear = int.parse(dateFormat.format(DateTime.now()));
    final DateTime? d = await showDatePicker(
      context: Get.context as BuildContext,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(currentYear - 100),
      lastDate: lastDate ?? DateTime(currentYear + 1),
    );
    if (d != null) {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd");
      return showTimePickerDialog(selectedDate: dateFormat.format(d));
    }
    return null;
  }

  static Future<String?> showTimePickerDialog({
    String? selectedDate,
  }) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: Get.context as BuildContext,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        );
      },
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (timeOfDay != null) {
      final localization =
          MaterialLocalizations.of(Get.context as BuildContext);
      String formattedTime = localization.formatTimeOfDay(
        timeOfDay,
        alwaysUse24HourFormat: true,
      );
      return "${selectedDate != null ? "$selectedDate " : ""}$formattedTime";
    }
    return null;
  }

  static String? stringDateTimeValidation({
    String? startDate,
    String? startTime,
    String? endDate,
    String? endTime,
  }) {
    try {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd hh:mm");
      DateTime startDateTime = dateFormat
          .parse("${startDate ?? currentDate()} ${startTime ?? currentTime()}");
      DateTime endDateTime = dateFormat
          .parse("${endDate ?? currentDate()} ${endTime ?? currentTime()}");

      if (startDateTime.isAfter(endDateTime) ||
          startDateTime.isAtSameMomentAs(endDateTime)) {
        return "Not valid!!!";
      } else {
        return null;
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "DateTimeUtils");
    }
    return null;
  }

  static bool checkIfTimeSlotEmpty({
    required DateTime? objStartDt,
    required DateTime? onjEndDt,
    required String? startDt,
    required String? endDt,
  }) {
    try {
      DateTime? startTime = DateTimeUtils.stringToDateTime(string: startDt);
      DateTime? endTime = DateTimeUtils.stringToDateTime(string: endDt);
      if ((objStartDt!.isAfter(startTime!) && objStartDt.isBefore(endTime!)) ||
          (onjEndDt!.isAfter(startTime) && onjEndDt.isBefore(endTime!))) {
        return true;
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "DateTimeUtils");
    }
    return false;
  }
}
