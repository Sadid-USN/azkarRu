import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';


class HijriPickerScreen extends StatefulWidget {
  const HijriPickerScreen({Key? key}) : super(key: key);

  @override
  _HijriPickerScreenState createState() => _HijriPickerScreenState();
}

class _HijriPickerScreenState extends State<HijriPickerScreen> {
  HijriCalendar selectedDate = HijriCalendar.now();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color(0xffF3EEE2),
        // appBar: AppBar(
        //   leading: IconButton(
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //       icon: const Icon(
        //         Icons.arrow_back_ios,
        //         color: iconColor,
        //       )),
        //   elevation: 3.0,
        //   backgroundColor: const Color(0xffF2DFC7),
        //   title: Text(LocaleKeys.hijri.tr(),
        //       style: TextStyle(fontSize: 15.sp, color: titleAbbBar)),
        //   centerTitle: true,
        // ),
        // ignore: avoid_unnecessary_containers, sized_box_for_whitespace
        body: SizedBox(),
        // Container(
        //   height: double.infinity,
        //   decoration: mainScreenGradient,
        //   width: double.infinity,
        //   child: 
          
        //   HijriMonthPicker(

        //     lastDate: HijriCalendar()
        //       ..hYear = 1445
        //       ..hMonth = 9
        //       ..hDay = 25,
        //     firstDate: HijriCalendar()
        //       ..hYear = 1438
        //       ..hMonth = 12
        //       ..hDay = 25,
        //     onChanged: (HijriCalendar value) {
        //       setState(() {
        //         selectedDate = value;
        //       });
        //     },
        //     selectedDate: selectedDate,
        //   ),
        // )
        
        );
  }
}
