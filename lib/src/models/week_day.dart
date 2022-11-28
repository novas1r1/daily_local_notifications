import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class WeekDay {
  final String firstLetter;
  final String name;
  final String shortName;
  final bool isActive;
  final int dayIndex;

  const WeekDay({
    required this.name,
    required this.firstLetter,
    required this.shortName,
    required this.isActive,
    required this.dayIndex,
  });

  factory WeekDay.fromJson(String source) =>
      WeekDay.fromMap(json.decode(source) as Map<String, dynamic>);

  factory WeekDay.fromMap(Map<String, dynamic> map) {
    return WeekDay(
      firstLetter: (map['firstLetter'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      shortName: (map['shortName'] ?? '') as String,
      isActive: (map['isActive'] ?? false) as bool,
      dayIndex: (map['dayIndex'] ?? 0) as int,
    );
  }

  WeekDay copyWith({
    String? firstLetter,
    String? name,
    String? shortName,
    bool? isActive,
    int? dayIndex,
  }) {
    return WeekDay(
      firstLetter: firstLetter ?? this.firstLetter,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      isActive: isActive ?? this.isActive,
      dayIndex: dayIndex ?? this.dayIndex,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    return result
      ..addAll({'firstLetter': firstLetter})
      ..addAll({'name': name})
      ..addAll({'shortName': shortName})
      ..addAll({'isActive': isActive})
      ..addAll({'dayIndex': dayIndex});
  }

  String toJson() => json.encode(toMap());

  static List<WeekDay> get initialWeekDays => [
        const WeekDay(
          name: 'Monday',
          shortName: 'Mon',
          isActive: true,
          firstLetter: 'M',
          dayIndex: DateTime.monday,
        ),
        const WeekDay(
          name: 'Tuesday',
          shortName: 'Tue',
          isActive: true,
          firstLetter: 'T',
          dayIndex: DateTime.tuesday,
        ),
        const WeekDay(
          name: 'Wednesday',
          shortName: 'Wed',
          isActive: true,
          firstLetter: 'W',
          dayIndex: DateTime.wednesday,
        ),
        const WeekDay(
          name: 'Thursday',
          shortName: 'Thu',
          isActive: true,
          firstLetter: 'T',
          dayIndex: DateTime.thursday,
        ),
        const WeekDay(
          name: 'Friday',
          shortName: 'Fri',
          isActive: true,
          firstLetter: 'F',
          dayIndex: DateTime.friday,
        ),
        const WeekDay(
          name: 'Saturday',
          shortName: 'Sat',
          isActive: true,
          firstLetter: 'S',
          dayIndex: DateTime.saturday,
        ),
        const WeekDay(
          name: 'Sunday',
          shortName: 'Sun',
          isActive: true,
          firstLetter: 'S',
          dayIndex: DateTime.sunday,
        ),
      ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeekDay &&
        other.firstLetter == firstLetter &&
        other.name == name &&
        other.shortName == shortName &&
        other.isActive == isActive &&
        other.dayIndex == dayIndex;
  }

  @override
  int get hashCode {
    return firstLetter.hashCode ^
        name.hashCode ^
        shortName.hashCode ^
        isActive.hashCode ^
        dayIndex.hashCode;
  }

  @override
  String toString() {
    return 'WeekDay(firstLetter: $firstLetter, name: $name, shortName: $shortName, isActive: $isActive, dayIndex: $dayIndex)';
  }
}
