import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dialogs.dart' as dg;
import 'widgets.dart' as wid;
class HealthData extends StatefulWidget {
  @override
  _HealthDataState createState() => _HealthDataState();
}

class _HealthDataState extends State<HealthData> {
  final String apiUrl = 'https://raw.githubusercontent.com/mornville/testServer/master/db.json';
  Future<void> fetchData() async {}
  @override
  void initState() {
    super.initState();
  }

  String week_number = "Week 1";
  Map data = Map();
  int flag = 0;

  List<String> positiveInsights = List<String>();
  List<String> negativeInsights = List<String>();
  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> filterData(BuildContext context, Map data, int get_week) async {
    Map temp = Map();
    List keys  = data.keys.toList();
    print("Filtering data");
    setState(() {
      for(int i=0; i<(keys.length); i++){
        if(keys[i]!='ideal_data'){
          temp[keys[i]] = data[keys[i]][get_week];
        }

        flag = 1;
      }
      weeklyStats = temp;
    });

  }

  Future<void> compareData(BuildContext context, Map data) async {
    print(data);
    negativeInsights = [];
    positiveInsights = [];
    // Heart Rate
    if(data["heartRate"]>80 && data["bmi"]>25){
      negativeInsights.add("Increased risk of T2 diabetes due to high bmi and heart rate");
    }
    if(data["heartRate"]>81){
      negativeInsights.add('Your resting heart rate is too high, consult cardiologist NOW!');
    }
    else if(data["heartRate"]>75 && data["heartRate"]<81){
      negativeInsights.add(" High Heart Rate, Consult a doctor for heart disease (hypertension, lipids). typical root cause is high cholesterol");
    }
    // Steps
    if(data["step_counts"] > 50000){
      double perc = ((data["step_counts"] - 50000)/50000)*100;
      positiveInsights.add('Good Job! Your daily steps is ${perc.round()}% higher than average');
    }else if(data["step_counts"] < 45000){
      double perc = ((data["step_counts"] - 50000)/50000)*100;
       negativeInsights.add('Your daily steps is ${perc.round()*-1}% lower than average');
    }

    if(data["appleExerciseTime"]>30){
      double perc = ((data["appleExerciseTime"] - 30)/30)*100;
      positiveInsights.add('Keep it Up! Your daily exercise time is ${perc.round()}% higher than average');

    }else if(data["appleExerciseTime"]<20){
      double perc = ((data["appleExerciseTime"] - 30)/30)*100;
      negativeInsights.add('Your Exercise time is ${perc.round()*-1}% lower than average');
    }
    if(data["aqi"]>100 && data["aqi"]<300){
      negativeInsights.add('Breathing discomfort for sensitive population');

    }else if(data["aqi"]>300){
      negativeInsights.add('Prolonged exposure could lead to lung and heart diseases - Air Purifier a must!');

    }

    if(data["bm"]>70){
      double perc = ((data["bm"] - 60)/60)*100;
      negativeInsights.add('Need more Exercise! Your weight is ${perc.round()}% higher than average');

    }else if(data["bm"]<50){
      double perc = ((data["bm"] - 60)/60)*100;
      negativeInsights.add('Your weight is ${perc.round()*-1}% lower than average');
    }


    if(data["bmi"]<18.5){
      double perc = ((data["bmi"] - 25)/60)*100;
      negativeInsights.add('You are underweight, your BMI is ${perc.round()*-1}% lower than average');

    }else if(data["bmi"]>25){
      double perc = ((data["bmi"] - 25)/25)*100;
      negativeInsights.add('You are overweight, Your BMI is ${perc.round()*1}% higher than average');
    }


    print("Negative" + negativeInsights.toString());
    print("Positive" + positiveInsights.toString());
    print('--');
  }
    Future<void> _getData(BuildContext context, int get_week, int flag) async {
    try {
      dg.Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
      print("inside preform logic method");
      if(flag == 0){
        var result = await http.get(apiUrl);

        data = json.decode(result.body);
        print(data);
        if(data.isNotEmpty) {
          filterData(context, data, get_week);
          compareData(context, weeklyStats);
          Navigator.pop(context); //close the dialogue

        } else {
          Navigator.pop(context); //close the dialogue
          dg.showDialogBox(
              context, 'Make sure you are connected to the internet.');
        }
      }
      else{
        filterData(context, data, get_week);
        compareData(context, weeklyStats);
        Navigator.pop(context); //close the dialogue

      }



    } catch (error) {
      print(error);
    }
    // Getting smitty api instance and shared_preference storage instance
  }

  //KeyLoader for Dialog
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<String> weeks = [
    "Week 1",
    "Week 2",
    "Week 3",
    "Week 4",
    "Week 5",
  ];
  int get_week = 0;
  Map weeklyStats = Map();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/back.png"), fit: BoxFit.fill)),

            ),
            SingleChildScrollView(
                child: Container(

                  child: Padding(
                    padding:  EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        DropdownButton<String>(
                          value: week_number,
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500),
                          underline: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              week_number = newValue;
                              print(week_number.split(' '));
                              get_week = int.parse(week_number.split(' ')[1]);
                            });
                            if(flag == 0){
                              _getData(context, get_week, 0);

                            }
                            else{
                              _getData(context, get_week, 1);
                            }
                          },
                          items: weeks.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(width: 20),
                                  Text(
                                    value,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 17.0,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        weeklyStats.isNotEmpty?wid.CardInfo(weeklyStats, 'Activity', 'activity.png', Colors.black):Container(),
                        weeklyStats.isNotEmpty?wid.CardInfo(weeklyStats, 'Vitals', 'vitals.png', Colors.black):Container(),
                        weeklyStats.isNotEmpty?wid.CardInfo(weeklyStats, 'Environment', 'weather.png', Colors.black):Container(),
                        weeklyStats.isNotEmpty? Card(
                          elevation: 10.0,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: ListTile(
                              title: Text(
                                'Insights',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w700, fontSize: 20.0),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height:10.0),
                                  negativeInsights.isNotEmpty?wid.getTextWidgets(negativeInsights, Colors.redAccent):Container(),
                                  positiveInsights.isNotEmpty?wid.getTextWidgets(positiveInsights, Colors.green):Container(),

                                  SizedBox(
                                    height: 10.0,
                                  ),

                                  SizedBox(
                                    height: 10.0,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ):Container(),


                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
