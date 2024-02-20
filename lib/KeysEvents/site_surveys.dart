import 'package:assingment/widget/style.dart';
import 'package:flutter/material.dart';

class SiteSurveys extends StatefulWidget {
  String? title;
  SiteSurveys({super.key, this.title});

  @override
  State<SiteSurveys> createState() => _SiteSurveysState();
}

class _SiteSurveysState extends State<SiteSurveys> {
  List<String> surveylist = [
    '1. Initial Survey Of Depot With TML & STA Team.',
    '2. Details Survey Of Depot With TPC Civil & Electrical Team',
    '3. Survey Report Submission With Existing & Proposed Layout Drawings.',
    '4. Job Scope Finalization & Preparation Of BOQ',
    '5. Power Connection / Load Applied By STA To Discom.'
  ];
  List<String> startdate = [
    '22/10/11',
    '25/10/11',
    '27/10/11',
    '29/10/11',
    '01/11/11',
  ];
  List<String> startdate1 = [
    '22/10/11',
    '25/10/11',
    '27/10/11',
    '29/10/11',
    '01/11/11',
  ];
  List<String> lastdate1 = [
    '01/11/12',
    '02/11/12',
    '03/11/12',
    '04/11/12',
    '05/11/12',
  ];
  List<String> lastdate = [
    '01/11/12',
    '02/11/12',
    '03/11/12',
    '04/11/12',
    '05/11/12',
  ];
  List<String> delay = [
    '9',
    '7',
    '6',
    '5',
    '4',
  ];
  List<String> Progress = [
    '1.25%',
    '7',
    '6',
    '5',
    '4',
  ];
  List<String> weightage = ['0.5%', '1.0%', '0.3%', '0.5%', '0.3%'];
  List<String> progress = ['1.5%', '1.25%', '0.3%', '0.5%', '0.3%'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Site Surveys'),
          backgroundColor: blue,
        ),
        body: ListTile(
          title: Text(widget.title.toString()),
          subtitle: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, i) {
              return cards2(
                  surveylist[i],
                  startdate1[i],
                  lastdate1[i],
                  startdate[i],
                  lastdate[i],
                  delay[i],
                  progress[i],
                  weightage[i]);
            },
          ),
        ));
  }

  // Widget cards(String title) {
  //   return Column(
  //     children: [
  //       Text(
  //         title,
  //         style: const TextStyle(fontSize: 17),
  //       ),
  //     ],
  //   );
  // }

  Widget cards2(
      String subtitle,
      String startdate,
      String startdate1,
      String enddate1,
      String enddate,
      String delay,
      String progress,
      String weightage) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: blue),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Text(subtitle),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Assigned Date'),
                    Text(startdate),
                    Text('To'),
                    Text(enddate),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Working Date'),
                    Text(startdate1),
                    Text('To'),
                    Text(enddate1),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delay'),
                    Text(delay),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('% of Progress'),
                    Text(progress),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Weightage'),
                    Text(weightage),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
