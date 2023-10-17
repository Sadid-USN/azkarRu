import 'package:equatable/equatable.dart';

class PrayersModel extends Equatable {
  final int? code;
  final String? status;
  final Data? data;

  const PrayersModel({
    this.code,
    this.status,
    this.data,
  });

  @override
  List<Object?> get props => [code, status, data];

  PrayersModel.fromJson(Map<String, dynamic> json)
      : code = json['code'] as int?,
        status = json['status'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? Data.fromJson(json['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'code': code,
        'status': status,
        'data': data?.toJson(),
      };
}

class Data extends Equatable {
  final Timings? timings;
  final Date? date;
  final Meta? meta;

  const Data({
    this.timings,
    this.date,
    this.meta,
  });

  @override
  List<Object?> get props => [timings, date, meta];

  Data.fromJson(Map<String, dynamic> json)
      : timings = (json['timings'] as Map<String, dynamic>?) != null
            ? Timings.fromJson(json['timings'] as Map<String, dynamic>)
            : null,
        date = (json['date'] as Map<String, dynamic>?) != null
            ? Date.fromJson(json['date'] as Map<String, dynamic>)
            : null,
        meta = (json['meta'] as Map<String, dynamic>?) != null
            ? Meta.fromJson(json['meta'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'timings': timings?.toJson(),
        'date': date?.toJson(),
        'meta': meta?.toJson(),
      };
}

class Timings extends Equatable {
  final String? fajr;
  final String? sunrise;
  final String? dhuhr;
  final String? asr;
  final String? sunset;
  final String? maghrib;
  final String? isha;
  final String? imsak;
  final String? midnight;
  final String? firstthird;
  final String? lastthird;

  const Timings({
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.sunset,
    this.maghrib,
    this.isha,
    this.imsak,
    this.midnight,
    this.firstthird,
    this.lastthird,
  });

  @override
  List<Object?> get props => [
        fajr,
        sunrise,
        dhuhr,
        asr,
        sunset,
        maghrib,
        isha,
        imsak,
        midnight,
        firstthird,
        lastthird,
      ];

  Timings.fromJson(Map<String, dynamic> json)
      : fajr = json['Fajr'] as String?,
        sunrise = json['Sunrise'] as String?,
        dhuhr = json['Dhuhr'] as String?,
        asr = json['Asr'] as String?,
        sunset = json['Sunset'] as String?,
        maghrib = json['Maghrib'] as String?,
        isha = json['Isha'] as String?,
        imsak = json['Imsak'] as String?,
        midnight = json['Midnight'] as String?,
        firstthird = json['Firstthird'] as String?,
        lastthird = json['Lastthird'] as String?;

  Map<String, dynamic> toJson() => {
        'Fajr': fajr,
        'Sunrise': sunrise,
        'Dhuhr': dhuhr,
        'Asr': asr,
        'Sunset': sunset,
        'Maghrib': maghrib,
        'Isha': isha,
        'Imsak': imsak,
        'Midnight': midnight,
        'Firstthird': firstthird,
        'Lastthird': lastthird,
      };
}

class Date {
  final String? readable;
  final String? timestamp;
  final Hijri? hijri;
  final Gregorian? gregorian;

  Date({
    this.readable,
    this.timestamp,
    this.hijri,
    this.gregorian,
  });

  Date.fromJson(Map<String, dynamic> json)
      : readable = json['readable'] as String?,
        timestamp = json['timestamp'] as String?,
        hijri = (json['hijri'] as Map<String, dynamic>?) != null
            ? Hijri.fromJson(json['hijri'] as Map<String, dynamic>)
            : null,
        gregorian = (json['gregorian'] as Map<String, dynamic>?) != null
            ? Gregorian.fromJson(json['gregorian'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'readable': readable,
        'timestamp': timestamp,
        'hijri': hijri?.toJson(),
        'gregorian': gregorian?.toJson()
      };
}

class Hijri {
  final String? date;
  final String? format;
  final String? day;
  final WeekdayArabic? weekday;
  final MonthArabic? month;
  final String? year;
  final DesignationExpanded? designation;
  final List<dynamic>? holidays;

  Hijri({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.designation,
    this.holidays,
  });

  Hijri.fromJson(Map<String, dynamic> json)
      : date = json['date'] as String?,
        format = json['format'] as String?,
        day = json['day'] as String?,
        weekday = (json['weekday'] as Map<String, dynamic>?) != null
            ? WeekdayArabic.fromJson(json['weekday'] as Map<String, dynamic>)
            : null,
        month = (json['month'] as Map<String, dynamic>?) != null
            ? MonthArabic.fromJson(json['month'] as Map<String, dynamic>)
            : null,
        year = json['year'] as String?,
        designation = (json['designation'] as Map<String, dynamic>?) != null
            ? DesignationExpanded.fromJson(
                json['designation'] as Map<String, dynamic>)
            : null,
        holidays = json['holidays'] as List?;

  Map<String, dynamic> toJson() => {
        'date': date,
        'format': format,
        'day': day,
        'weekday': weekday?.toJson(),
        'month': month?.toJson(),
        'year': year,
        'designation': designation?.toJson(),
        'holidays': holidays
      };
}

class WeekdayArabic {
  final String? en;
  final String? ar;

  WeekdayArabic({
    this.en,
    this.ar,
  });

  WeekdayArabic.fromJson(Map<String, dynamic> json)
      : en = json['en'] as String?,
        ar = json['ar'] as String?;

  Map<String, dynamic> toJson() => {'en': en, 'ar': ar};
}

class MonthArabic {
  final int? number;
  final String? en;
  final String? ar;

  MonthArabic({
    this.number,
    this.en,
    this.ar,
  });

  MonthArabic.fromJson(Map<String, dynamic> json)
      : number = json['number'] as int?,
        en = json['en'] as String?,
        ar = json['ar'] as String?;

  Map<String, dynamic> toJson() => {'number': number, 'en': en, 'ar': ar};
}

class DesignationExpanded {
  final String? abbreviated;
  final String? expanded;

  DesignationExpanded({
    this.abbreviated,
    this.expanded,
  });

  DesignationExpanded.fromJson(Map<String, dynamic> json)
      : abbreviated = json['abbreviated'] as String?,
        expanded = json['expanded'] as String?;

  Map<String, dynamic> toJson() =>
      {'abbreviated': abbreviated, 'expanded': expanded};
}

class Gregorian {
  final String? date;
  final String? format;
  final String? day;
  final WeekdayArabic? weekday;
  final MonthArabic? month;
  final String? year;
  final DesignationExpanded? designation;

  Gregorian({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.designation,
  });

  Gregorian.fromJson(Map<String, dynamic> json)
      : date = json['date'] as String?,
        format = json['format'] as String?,
        day = json['day'] as String?,
        weekday = (json['weekday'] as Map<String, dynamic>?) != null
            ? WeekdayArabic.fromJson(json['weekday'] as Map<String, dynamic>)
            : null,
        month = (json['month'] as Map<String, dynamic>?) != null
            ? MonthArabic.fromJson(json['month'] as Map<String, dynamic>)
            : null,
        year = json['year'] as String?,
        designation = (json['designation'] as Map<String, dynamic>?) != null
            ? DesignationExpanded.fromJson(
                json['designation'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'date': date,
        'format': format,
        'day': day,
        'weekday': weekday?.toJson(),
        'month': month?.toJson(),
        'year': year,
        'designation': designation?.toJson()
      };
}

class Weekday {
  final String? en;

  Weekday({
    this.en,
  });

  Weekday.fromJson(Map<String, dynamic> json) : en = json['en'] as String?;

  Map<String, dynamic> toJson() => {'en': en};
}

class Month {
  final int? number;
  final String? en;

  Month({
    this.number,
    this.en,
  });

  Month.fromJson(Map<String, dynamic> json)
      : number = json['number'] as int?,
        en = json['en'] as String?;

  Map<String, dynamic> toJson() => {'number': number, 'en': en};
}

class Designation {
  final String? abbreviated;
  final String? expanded;

  Designation({
    this.abbreviated,
    this.expanded,
  });

  Designation.fromJson(Map<String, dynamic> json)
      : abbreviated = json['abbreviated'] as String?,
        expanded = json['expanded'] as String?;

  Map<String, dynamic> toJson() =>
      {'abbreviated': abbreviated, 'expanded': expanded};
}

class Meta {
  final double? latitude;
  final double? longitude;
  final String? timezone;
  final Method? method;
  final String? latitudeAdjustmentMethod;
  final String? midnightMode;
  final String? school;
  final Offsets? offset;

  Meta({
    this.latitude,
    this.longitude,
    this.timezone,
    this.method,
    this.latitudeAdjustmentMethod,
    this.midnightMode,
    this.school,
    this.offset,
  });

  Meta.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'] as double?,
        longitude = json['longitude'] as double?,
        timezone = json['timezone'] as String?,
        method = (json['method'] as Map<String, dynamic>?) != null
            ? Method.fromJson(json['method'] as Map<String, dynamic>)
            : null,
        latitudeAdjustmentMethod = json['latitudeAdjustmentMethod'] as String?,
        midnightMode = json['midnightMode'] as String?,
        school = json['school'] as String?,
        offset = (json['offset'] as Map<String, dynamic>?) != null
            ? Offsets.fromJson(json['offset'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'timezone': timezone,
        'method': method?.toJson(),
        'latitudeAdjustmentMethod': latitudeAdjustmentMethod,
        'midnightMode': midnightMode,
        'school': school,
        'offset': offset?.toJson()
      };
}

class Method {
  final int? id;
  final String? name;
  final Params? params;
  final Location? location;

  Method({
    this.id,
    this.name,
    this.params,
    this.location,
  });

  Method.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        params = (json['params'] as Map<String, dynamic>?) != null
            ? Params.fromJson(json['params'] as Map<String, dynamic>)
            : null,
        location = (json['location'] as Map<String, dynamic>?) != null
            ? Location.fromJson(json['location'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'params': params?.toJson(),
        'location': location?.toJson()
      };
}

class Params {
  final double? fajr;
  final String? isha;

  Params({
    this.fajr,
    this.isha,
  });

  Params.fromJson(Map<String, dynamic> json)
      : fajr = json['Fajr'] as double?,
        isha = json['Isha'] as String?;

  Map<String, dynamic> toJson() => {'Fajr': fajr, 'Isha': isha};
}

class Location {
  final double? latitude;
  final double? longitude;

  Location({
    this.latitude,
    this.longitude,
  });

  Location.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'] as double?,
        longitude = json['longitude'] as double?;

  Map<String, dynamic> toJson() =>
      {'latitude': latitude, 'longitude': longitude};
}

class Offsets {
  final int? imsak;
  final int? fajr;
  final int? sunrise;
  final int? dhuhr;
  final int? asr;
  final int? maghrib;
  final int? sunset;
  final int? isha;
  final int? midnight;

  Offsets({
    this.imsak,
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.maghrib,
    this.sunset,
    this.isha,
    this.midnight,
  });

  Offsets.fromJson(Map<String, dynamic> json)
      : imsak = json['Imsak'] as int?,
        fajr = json['Fajr'] as int?,
        sunrise = json['Sunrise'] as int?,
        dhuhr = json['Dhuhr'] as int?,
        asr = json['Asr'] as int?,
        maghrib = json['Maghrib'] as int?,
        sunset = json['Sunset'] as int?,
        isha = json['Isha'] as int?,
        midnight = json['Midnight'] as int?;

  Map<String, dynamic> toJson() => {
        'Imsak': imsak,
        'Fajr': fajr,
        'Sunrise': sunrise,
        'Dhuhr': dhuhr,
        'Asr': asr,
        'Maghrib': maghrib,
        'Sunset': sunset,
        'Isha': isha,
        'Midnight': midnight
      };
}
