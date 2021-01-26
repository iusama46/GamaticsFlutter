
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'meet_name.dart';
class Add_competition extends StatefulWidget {
  static const routename = "add_competition";
 final String name;
Add_competition({this.name});
  @override
  _Add_competitionState createState() => _Add_competitionState();
}

class _Add_competitionState extends State<Add_competition> {
  final _form = GlobalKey<FormState>();
  bool datepicked = false;
  String selected_value;
  DateTime date = DateTime.now();
  String selected_competition_location;
  List competition_location_list = [];
  TextEditingController name_controller=TextEditingController();
  TextEditingController Conpetitionlevel_controller=TextEditingController();
  TextEditingController Conpetition_location_controller=TextEditingController();

  Future get_competition_location_data() async {
    final response = await http.get(
        "http://hpsport.in/api/v3/get_competition_level.php?tag=fetchcompetitionlevel&LoggedinUserID=1");
    if (response.statusCode == 200) {
      var respoonsedata = response.body;
      var data = jsonDecode(respoonsedata);
      data = data['units_details'];

      for (var i in data) {
        competition_location_list.add(i['CompetitionLevelName']);
      }
      competition_location_list.forEach((element) {
        print(element);
      });
    } else {
      print(response.statusCode);
    }
  }

  Future<Null> selectDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1940),
      lastDate: DateTime(2022),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        print(date.toString());
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_competition_location_data();
  }

  insert()async{
    var url=await "http://www.hpsport.in/api/v3/put_performance.php?p=addperformance&OperationMode=add&LoggedinUserID=1&SportsEventID=54&CompetitionID=2725&CompetitionName=Karnataka%20state%20inter%20district%20Junior%20Athletic%20Championship%202019&CompetitionLocation=udupi&CompetitionDate=2019-08-23&AthleteComments=athlete%20comment%20text&EventRank=1&EventTypeID=7&ResultType=Time&ScoringType=Time&SportsID=2&RecordName=&isRecord=0&EventResult_Time=00:00:34.380&EventResult_Points=&EventResult_Points2=&EventResult_Points3=&EventResult_Distance=&UnitsID=&sportsname=Athletics";
    var response=http.post(url,body: jsonEncode({
      'Competition_name':name_controller.text,
      'CompetitionLocation':Conpetition_location_controller.text,
      'CompetitionDate':datepicked.toString(),

    }));
  return response;
  }

  void _saveform() {
    final isvalid = _form.currentState.validate();

    if (!isvalid) {
      return;
    } else {
      _form.currentState.save();

      Navigator.of(context).pop();
    }
  }



  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return Scaffold(

      appBar: AppBar(
        title: Text("Add Composition"),
        centerTitle: true,
      ),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Competion/Meet Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(width: 0.4),
                ),
                elevation: 2,
                child: Container( height: mediaquery.size.height * 0.09,
                  width: mediaquery.size.width * 0.40,
                padding: EdgeInsets.only(left: 10,top: 15),
                child: TextFormField(
                  decoration: InputDecoration(hintText: "Name"),
               controller: name_controller,
                )),
              ),
              SizedBox(
                height: mediaquery.size.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Competion/Meet Date",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(width: 0.4),
                ),
                elevation: 2,
                child: Container(
                  height: mediaquery.size.height * 0.09,
                  width: mediaquery.size.width * 0.40,
                  padding: EdgeInsets.only(left: 15, right: 12, top: 9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(datepicked
                          ? date.day.toString() +
                              " /" +
                              date.month.toString() +
                              " /" +
                              date.year.toString()
                          : "Select Competition Date"),
                      IconButton(
                        icon: Icon(
                          Icons.date_range,
                          color: Colors.lightBlueAccent,
                          size: 35,
                        ),
                        onPressed: () {
                          selectDatePicker(context);
                          setState(() {
                            datepicked = true;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: mediaquery.size.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Competion/Meet Location",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(width: 0.4),
                ),
                elevation: 2,
                child: Container(
                  height: mediaquery.size.height * 0.09,
                  width: mediaquery.size.width * 0.40,
                  padding: EdgeInsets.only(left: 15),
                  child: TextFormField(
                    controller: Conpetition_location_controller,
                    decoration: InputDecoration(
                      hintText: "Location(City)",
                      hintStyle: TextStyle(color: Colors.black38, fontSize: 13),
                      errorStyle: TextStyle(
                        color: Colors.red,
                      ),
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "invalid";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: mediaquery.size.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Competition Level",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: mediaquery.size.height * 0.01,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                child: Container(
                  height: mediaquery.size.height * 0.09,
                  width: mediaquery.size.width * 0.40,
                  padding: EdgeInsets.only(left: 15),
                  child: DropdownButton(
                    hint: Text(
                      "School/University",
                    ),
                    value: selected_competition_location,
                    onChanged: (value) {
                      setState(() {
                        selected_competition_location = value;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    isExpanded: true,
                    items: competition_location_list
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                  ),
                ),
              ),
              SizedBox(
                height: mediaquery.size.height * 0.01,
              ),
              FlatButton(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                    side: BorderSide(color: Colors.teal, width: 1.3),
                  ),
                  color: Colors.deepPurple,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 35, top: 25, bottom: 25, right: 24),
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          "Add Competition / Meet Result",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                onPressed: insert,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
