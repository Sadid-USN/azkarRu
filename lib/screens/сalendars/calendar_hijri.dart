import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hijri_picker/hijri_picker.dart';
import 'package:sizer/sizer.dart';

class HijriPickerScreen extends StatefulWidget {
  const HijriPickerScreen({Key? key}) : super(key: key);

  @override
  _HijriPickerScreenState createState() => _HijriPickerScreenState();
}

class _HijriPickerScreenState extends State<HijriPickerScreen> {
  HijriCalendar selectedDate = HijriCalendar.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: iconColor,
              )),
          flexibleSpace: Container(
            decoration: mainScreenGradient,
          ),
          elevation: 0.0,
          backgroundColor: gradientStartColor,
          title: Text('Каленьдарь хиджри',
              style: TextStyle(fontSize: 15.sp, color: titleAbbBar)),
          centerTitle: true,
        ),
        // ignore: avoid_unnecessary_containers, sized_box_for_whitespace
        body: Container(
          height: double.infinity,
          decoration: mainScreenGradient,
          width: double.infinity,
          child: HijriMonthPicker(
            lastDate: HijriCalendar()
              ..hYear = 1445
              ..hMonth = 9
              ..hDay = 25,
            firstDate: HijriCalendar()
              ..hYear = 1438
              ..hMonth = 12
              ..hDay = 25,
            onChanged: (HijriCalendar value) {
              setState(() {
                selectedDate = value;
              });
            },
            selectedDate: selectedDate,
          ),
        ));
  }
}
