import 'dart:ffi';
import 'home.dart';
import 'package:flutter/material.dart';
import 'package:intershipjobportal/add_city.dart';
import 'package:intershipjobportal/job_profile.dart';
import 'package:intershipjobportal/model/internshala.dart';

class FilterScreen extends StatefulWidget {
  final List<Map<dynamic, dynamic>> selectedonecities;
  final List<Map<dynamic, dynamic>> jobProfiles;
  FilterScreen({
    super.key,
    required this.selectedonecities,
    required this.jobProfiles,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  var value = '-1';
  List<DropdownMenuItem> list = [
    const DropdownMenuItem(
      value: '-1',
      child: Text('Choose Duration'),
    ),
    const DropdownMenuItem(
      value: '1',
      child: Text('1'),
    ),
    const DropdownMenuItem(
      value: '2',
      child: Text('2'),
    ),
    const DropdownMenuItem(
      value: '3',
      child: Text('3'),
    ),
    const DropdownMenuItem(
      value: '6',
      child: Text('6'),
    ),
    const DropdownMenuItem(
      value: '9',
      child: Text('9'),
    ),
    const DropdownMenuItem(
      value: '12',
      child: Text('12'),
    )
  ];
  // String selectedCity = '';
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 3, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PROFILE',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                    fontSize: 15)),
            SizedBox(
              height: height * 0.01,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Profile()));
                },
                child: InkWell(
                    onTap: () async {
                      Map<dynamic, dynamic> datalist_map = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Profile()));
                      if (datalist_map != null) {
                        setState(() {
                          widget.jobProfiles.add(datalist_map);
                        });
                      }
                    },
                    child: widget.jobProfiles.isEmpty
                        ? Row(
                            children: [
                              const Icon(
                                Icons.add_outlined,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: width * 0.03,
                              ),
                              Text(
                                'Add Profile',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue),
                              )
                            ],
                          )
                        : Wrap(
                            spacing: 2,
                            children: widget.jobProfiles.map((profiles) {
                              return Container(
                                width: width * 0.4,
                                height: height * 0.08,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: Colors.lightBlueAccent,
                                        width: 2)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: width * 0.2,
                                      height: height * 0.08,
                                      child: Text(
                                        profiles['name'],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          print(widget.jobProfiles);
                                          setState(() {
                                            widget.jobProfiles.remove(profiles);
                                          });
                                        },
                                        icon: Icon(Icons.delete))
                                  ],
                                ),
                              );
                            }).toList(),
                          ))),
            SizedBox(
              height: height * 0.015,
            ),
            Text('CITY',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                    fontSize: 15)),
            SizedBox(
              height: height * 0.01,
            ),
            GestureDetector(
                onTap: () async {
                  Map<dynamic, dynamic> datalist = await Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => const City()));

                  if (datalist != null) {
                    setState(() {
                      widget.selectedonecities.add(datalist);
                    });
                  }
                },
                child: widget.selectedonecities.isEmpty
                    ? Row(
                        children: [
                          const Icon(
                            Icons.add_outlined,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: width * 0.03,
                          ),
                          Text(
                            'Add City',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.blue),
                          )
                        ],
                      )
                    : Wrap(
                        children: widget.selectedonecities.map((city) {
                          return Container(
                            width: width * 0.4,
                            height: height * 0.08,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.lightBlue, width: 2)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: width * 0.2,
                                  height: height * 0.04,
                                  child: Text(city['name']),
                                ),
                                IconButton(
                                    onPressed: () {
                                      widget.selectedonecities.remove(city);
                                      setState(() {});
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            ),
                          );
                        }).toList(),
                      )),
            SizedBox(
              height: height * 0.015,
            ),
            Text('MAXIMUM DURATION (IN MONTHS)',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                    fontSize: 15)),
            SizedBox(
              height: height * 0.015,
            ),
            DropdownButtonFormField(
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_outlined,
                color: Colors.black,
              ),
              decoration: const InputDecoration(border: OutlineInputBorder()),
              value: value,
              items: list,
              onChanged: (v) {
                setState(() {
                  value = v;
                });
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: width * 0.4,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                color: Colors.transparent,
              ),
              child: const Center(
                child: Text(
                  'Clear all',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (widget.jobProfiles.isEmpty ||
                    widget.selectedonecities.isEmpty ||
                    value == '-1') {
                  print('presses');
                } else {
                  Navigator.pop(context, {
                    'jobprofile': widget.jobProfiles,
                    'selectedcities': widget.selectedonecities,
                    'value': value
                  });
                }
              },
              child: Container(
                width: width * 0.4,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: const Center(
                  child: Text(
                    'Apply',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
