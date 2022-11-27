import 'dart:convert';

class WeekDay {
  final String firstLetter;
  final String name;
  final String shortName;
  final bool isActive;

  const WeekDay({
    required this.name,
    required this.firstLetter,
    required this.shortName,
    required this.isActive,
  });

  factory WeekDay.fromJson(String source) =>
      WeekDay.fromMap(json.decode(source) as Map<String, dynamic>);

  factory WeekDay.fromMap(Map<String, dynamic> map) {
    return WeekDay(
      firstLetter: (map['firstLetter'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      shortName: (map['shortName'] ?? '') as String,
      isActive: (map['isActive'] ?? false) as bool,
    );
  }

  WeekDay copyWith({
    String? firstLetter,
    String? name,
    String? shortName,
    bool? isActive,
  }) {
    return WeekDay(
      firstLetter: firstLetter ?? this.firstLetter,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    return result
      ..addAll({'firstLetter': firstLetter})
      ..addAll({'name': name})
      ..addAll({'shortName': shortName})
      ..addAll({'isActive': isActive});
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeekDay &&
        other.firstLetter == firstLetter &&
        other.name == name &&
        other.shortName == shortName &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return firstLetter.hashCode ^
        name.hashCode ^
        shortName.hashCode ^
        isActive.hashCode;
  }

  static List<WeekDay> get initialWeekDays => const [
        WeekDay(
          name: 'Monday',
          shortName: 'Mon',
          isActive: false,
          firstLetter: 'M',
        ),
        WeekDay(
          name: 'Tuesday',
          shortName: 'Tue',
          isActive: false,
          firstLetter: 'T',
        ),
        WeekDay(
          name: 'Wednesday',
          shortName: 'Wed',
          isActive: false,
          firstLetter: 'W',
        ),
        WeekDay(
          name: 'Thursday',
          shortName: 'Thu',
          isActive: false,
          firstLetter: 'T',
        ),
        WeekDay(
          name: 'Friday',
          shortName: 'Fri',
          isActive: false,
          firstLetter: 'F',
        ),
        WeekDay(
          name: 'Saturday',
          shortName: 'Sat',
          isActive: false,
          firstLetter: 'S',
        ),
        WeekDay(
          name: 'Sunday',
          shortName: 'Sun',
          isActive: false,
          firstLetter: 'S',
        ),
      ];
}
