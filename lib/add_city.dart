import 'package:flutter/material.dart';
import 'package:intershipjobportal/home.dart';
import 'list_of_all_cities.dart';

class City extends StatefulWidget {
  const City({super.key});

  @override
  State<City> createState() => _CityState();
}

class _CityState extends State<City> {
  List<Map<dynamic, dynamic>> selectedlist = [];
  Map<dynamic, dynamic> map = {};
  TextEditingController search = TextEditingController();
  List<Map<dynamic, dynamic>> filterlist = [];
  void updatelist(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        filterlist = profileNames;
      } else {
        filterlist = profileNames
            .where((city) =>
                city['name'].toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City'),
        actions: [
          const Text('Clear all',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context, map);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(5)),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Apply',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: Column(
          children: [
            TextFormField(
                controller: search,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    label: Text(
                      'Search city',
                      style: TextStyle(color: Colors.blue),
                    ),
                    border: OutlineInputBorder()),
                onChanged: (value) {
                  updatelist(value);
                }),
            Expanded(
              child: ListView.builder(
                itemCount: filterlist.length,
                itemBuilder: (context, index) {
                  print('filters');
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    selectedTileColor: Colors.blue,
                    title: Text(filterlist[index]["name"]),
                    value: filterlist[index]["checked"],
                    onChanged: (val) {
                      setState(() {
                        filterlist[index]["checked"] = val;
                        if (val == true) {
                          map.addAll(filterlist[index]);
                          selectedlist.add(filterlist[index]);
                        } else {
                          map.addAll(filterlist[index]);
                          selectedlist.remove(filterlist[index]);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
// Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 125,
//                             height: 25,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: Colors.lightBlue.shade100),
//                             child: ListView.builder(
//                                 itemCount: selectedonecities.length,
//                                 itemBuilder: (context, index) {
//                                   print('index : ->${index}');
//                                   return Row(
//                                     children: [
//                                       Text(selectedonecities![index]['name']),
//                                       InkWell(
//                                         onTap: () {
//                                           setState(() {
//                                             selectedonecities.remove(
//                                                 selectedonecities[index]);
//                                           });
//                                         },
//                                         child: Container(
//                                           child: Icon(Icons.delete),
//                                         ),
//                                       )
//                                     ],
//                                   );
//                                 }),
//                           ),
//                         ],
//                       )