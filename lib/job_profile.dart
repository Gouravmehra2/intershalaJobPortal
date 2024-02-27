import 'package:flutter/material.dart';
import 'package:intershipjobportal/filter_screen.dart';
import 'list_of_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController search = TextEditingController();
  List<Map<dynamic, dynamic>> filterlist = [];
  List<Map<dynamic, dynamic>> selectedlist = [];
  Map<dynamic, dynamic> map = {};
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
        title: Text('Profile'),
        actions: [
          Container(
            child: Text('Clear all',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, map);
                  },
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
              decoration: InputDecoration(
                  label: Text(
                    'Search profile',
                    style: TextStyle(color: Colors.blue),
                  ),
                  border: OutlineInputBorder()),
              onChanged: (value) {
                updatelist(value);
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filterlist.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    selectedTileColor: Colors.blue,
                    title: Text(filterlist[index]["name"]),
                    value: filterlist[index]["checked"],
                    onChanged: (val) {
                      filterlist[index]["checked"] = val;
                      setState(() {
                        if (val == true) {
                          map.addAll(filterlist[index]);
                          selectedlist.add(filterlist[index]);
                        } else {
                          map.remove(filterlist[index]);
                          selectedlist.remove(filterlist[index]);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
