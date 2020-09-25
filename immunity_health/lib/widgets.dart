
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget show_data(String title, String number, String unit){
  return  Padding(
    padding: EdgeInsets.all(3.0),
child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
         Flexible(
           child: Text(
                title + ' : ' ,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500),
              ),
         ),
        Text(
              number.toString() + ' ' + unit,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700),
            ),
        ],
      ),
  );
}


Widget CardInfo(
    Map stats, String type, String image, Color color) {
  return Card(
    elevation: 10.0,
    child: Padding(
      padding: EdgeInsets.only(top:10.0, left: 10.0),
      child: ListTile(
          title: Text(
            type,
            style: TextStyle(
                color: Colors.blue,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w700, fontSize: 20.0),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              type=='Activity'?Wrap(
                children: <Widget>[
                  show_data("Total Steps" , stats["step_counts"].toString(), ''),
                   show_data("Distance Travelled" , stats["distanceWalkingRunning"].toString(), 'Km'),
              show_data("Active Energy Burned" , stats["activeEnergyBurned"].toString(), 'kcal'),
               show_data("Basal Energy Burned" , stats["basalEnergyBurned"].toString(), 'kcal'),
                show_data("Exercise Time" , stats["appleExerciseTime"].toString(), 'min'),
                ],
              ):type=='Vitals'?Wrap(
                children: <Widget>[
                 show_data("Avg. Heart Rate" , stats["heartRate"].toString(), 'beats/min'),
              show_data("Resting Heart Rate" , stats["restingHeartRate"].toString(), 'beats/min'),
                 show_data("Walking Heart Rate" , stats["walkingHeartRateAverage"].toString(), 'beats/min'),
               show_data("Body Mass" , stats["bm"].toString(), 'Kg'),
                show_data("Body Mass Index" , stats["bmi"].toString(), 'kg/m2'),
                ],
              ):Wrap(
                children: <Widget>[
                    show_data("AQI" , stats["aqi"].toString(), ''),
                  show_data("Humidity" , stats["temp"].toString(), '%'),
                  show_data("Temperature " , stats["humidity"].toString(), 'C'),

                ],
              ),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
       ),
    ),
  );
}

Widget getTextWidgets(List strings, Color color)
{
  List<Widget> list =  List<Widget>();
  for(var i = 0; i < strings.length; i++){
    list.add(Padding(
      child: Text(strings[i], style: TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
            fontSize: 13.0, color: color),
      ),
      padding: EdgeInsets.all(5.0),
    ));
  }
  return Padding(
    child: Wrap(children: list),
    padding: EdgeInsets.all(2.0),
  );
}
