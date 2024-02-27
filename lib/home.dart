import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intershipjobportal/filter_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intershipjobportal/model/internshala.dart';

List<String> city = [];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<dynamic, dynamic>> profile = [];
  List<Map<dynamic, dynamic>> cities = [];

  var lengthdata;
  Future<Model> fetchdata() async {
    final response = await http
        .get(Uri.parse('https://internshala.com/flutter_hiring/search'));
    var data = jsonDecode(response.body);
    lengthdata = data['internship_ids'].length;
    return Model.fromJson(data);
  }

  bool search = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: search != true
          ? AppBar(
              elevation: 0,
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.dehaze),
                onPressed: () {},
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        search = !search;
                      });
                    },
                    icon: const Icon(
                      Icons.search_outlined,
                      size: 25,
                    ))
              ],
              title: const Text('Internships'),
            )
          : AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    search = !search;
                  });
                },
              ),
              title: TextFormField(
                decoration: const InputDecoration(
                    hintText: 'Category , location or company name'),
              ),
            ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 1.5),
                    borderRadius: BorderRadius.circular(40)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                  child: GestureDetector(
                    onTap: () async {
                      Map data = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FilterScreen(
                                    jobProfiles: [],
                                    selectedonecities: [],
                                  )));

                      if (data != null) {
                        setState(() {
                          profile = data['jobprofile'];
                          cities = data['selectedcities'];
                        });
                        // Now you have the two lists received from the second screen
                        print(profile);
                      }
                    },
                    child: Row(
                      children: [
                        Image(
                          image: const AssetImage('assets/images/filter.png'),
                          width: width * 0.035,
                          height: height * 0.03,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: width * 0.015,
                        ),
                        const Text(
                          'Filters',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                // ignore: unnecessary_brace_in_string_interps
                '${lengthdata}',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: width * 0.01,
              ),
              const Text(
                'Totals Internships',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          const Divider(
            thickness: 3,
          ),
          Expanded(
              child: profile.isEmpty || cities.isEmpty
                  ? FutureBuilder(
                      future: fetchdata(),
                      builder: (context, AsyncSnapshot<Model> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Fetching data from server ...'),
                                CircularProgressIndicator(
                                  color: Colors.blue,
                                )
                              ],
                            ),
                          );
                        }
                        List intershipId = snapshot.data!.internshipIds;
                        var intershipMeta = snapshot.data!.internshipsMeta;

                        // print(intership_meta);
                        return ListView.builder(
                            itemCount: intershipId.length,
                            itemBuilder: ((context, index) {
                              print('${index.toString()}');
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: width * 0.38,
                                          height: height * 0.04,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey.shade400),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Icon(
                                                Icons.trending_up_sharp,
                                                color: Colors.blue,
                                              ),
                                              SizedBox(
                                                width: width * 0.01,
                                              ),
                                              const Text(
                                                'Actively hiring',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.5,
                                          height: height * 0.09,
                                          child: Text(
                                            intershipMeta[intershipId[index]
                                                    .toString()]!
                                                .title
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.48,
                                          height: height * 0.07,
                                          child: Text(
                                            intershipMeta[intershipId[index]
                                                    .toString()]!
                                                .companyName
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            intershipMeta[intershipId[index]
                                                        .toString()]!
                                                    .locationNames
                                                    .isEmpty
                                                ? const Text('Remote')
                                                : const Icon(
                                                    Icons.location_on_outlined,
                                                    color: Colors.black87,
                                                  ),
                                            const SizedBox(
                                              width: 0.01,
                                            ),
                                            Text(intershipMeta[
                                                        intershipId[index]
                                                            .toString()]!
                                                    .locationNames
                                                    .isEmpty
                                                ? ''
                                                : intershipMeta[
                                                        intershipId[index]
                                                            .toString()]!
                                                    .locationNames[0]
                                                    .toString())
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.play_circle_outline,
                                              color: Colors.grey.shade800,
                                            ),
                                            SizedBox(
                                              width: width * 0.01,
                                            ),
                                            Text(
                                              intershipMeta[intershipId[index]
                                                      .toString()]!
                                                  .startDate
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(
                                              width: width * 0.08,
                                            ),
                                            Icon(
                                              Icons.calendar_today_outlined,
                                              color: Colors.grey.shade800,
                                            ),
                                            SizedBox(
                                              width: width * 0.02,
                                            ),
                                            Text(
                                              intershipMeta[intershipId[index]
                                                      .toString()]!
                                                  .duration
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: width * 0.05,
                                              height: height * 0.03,
                                              child: Image(
                                                  fit: BoxFit.cover,
                                                  color: Colors.grey.shade700,
                                                  image: const AssetImage(
                                                      'assets/images/money.png')),
                                            ),
                                            SizedBox(
                                              width: width * 0.01,
                                            ),
                                            SizedBox(
                                                width: width * 0.5,
                                                height: height * 0.03,
                                                child: Text(
                                                  intershipMeta[
                                                          intershipId[index]
                                                              .toString()]!
                                                      .stipend!
                                                      .salary
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              intershipMeta[intershipId[index]
                                                      .toString()]!
                                                  .employmentType
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.grey.shade900,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            intershipMeta[intershipId[index]
                                                                .toString()]!
                                                            .postedByLabel ==
                                                        'Today' ||
                                                    intershipMeta[intershipId[
                                                                    index]
                                                                .toString()]!
                                                            .postedByLabel ==
                                                        '1 day ago' ||
                                                    intershipMeta[intershipId[
                                                                    index]
                                                                .toString()]!
                                                            .postedByLabel ==
                                                        '2 days ago' ||
                                                    intershipMeta[intershipId[
                                                                    index]
                                                                .toString()]!
                                                            .postedByLabel ==
                                                        '3 days ago'
                                                ? Container(
                                                    width: width * 0.3,
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .lightGreenAccent
                                                            .withOpacity(0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.update,
                                                            color: Colors
                                                                .lightGreenAccent
                                                                .shade700,
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.01,
                                                          ),
                                                          Text(
                                                            intershipMeta[intershipId[
                                                                        index]
                                                                    .toString()]!
                                                                .postedByLabel
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .lightGreenAccent
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    width: width * 0.3,
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade300,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.update),
                                                          Text(
                                                            intershipMeta[intershipId[
                                                                        index]
                                                                    .toString()]!
                                                                .postedByLabel
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade900,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                            Container(
                                              width: width * 0.3,
                                              decoration: BoxDecoration(
                                                  color: Colors.red.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.info,
                                                      color:
                                                          Colors.red.shade900,
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.01,
                                                    ),
                                                    Text(
                                                      intershipMeta[
                                                              intershipId[index]
                                                                  .toString()]!
                                                          .applicationDeadline
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors
                                                              .red.shade900,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        const Divider(
                                          thickness: 2,
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 5, 0),
                                                child: Text(
                                                  'View details',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blue.shade800,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 17),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 10,
                                    color: Colors.grey.shade400,
                                  )
                                ],
                              );
                            }));
                      })
                  : Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: FutureBuilder(
                          future: fetchdata(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                snapshot.connectionState ==
                                    ConnectionState.none) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
                            List? intershipId = snapshot.data?.internshipIds;
                            var intershipMeta = snapshot.data!.internshipsMeta;
                            return ListView.builder(
                                itemCount: intershipId?.length,
                                itemBuilder: ((context, index) {
                                  if (intershipMeta[
                                          intershipId![index].toString()]!
                                      .locationNames
                                      .isEmpty) {
                                    return SizedBox();
                                  } else {
                                    return intershipMeta[intershipId![index]
                                                    .toString()]!
                                                .locationNames[0]
                                                .toString() ==
                                            cities[0]['name'].toString()
                                        ? Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: width * 0.38,
                                                      height: height * 0.04,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade400),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .trending_up_sharp,
                                                            color: Colors.blue,
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.01,
                                                          ),
                                                          const Text(
                                                            'Actively hiring',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.5,
                                                      height: height * 0.09,
                                                      child: Text(
                                                        intershipMeta[
                                                                intershipId[
                                                                        index]
                                                                    .toString()]!
                                                            .title
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 25),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.48,
                                                      height: height * 0.07,
                                                      child: Text(
                                                        intershipMeta[
                                                                intershipId[
                                                                        index]
                                                                    .toString()]!
                                                            .companyName
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey.shade700,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        intershipMeta[intershipId[
                                                                        index]
                                                                    .toString()]!
                                                                .locationNames
                                                                .isEmpty
                                                            ? const Text(
                                                                'Remote')
                                                            : const Icon(
                                                                Icons
                                                                    .location_on_outlined,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                        const SizedBox(
                                                          width: 0.01,
                                                        ),
                                                        Text(intershipMeta[
                                                                    intershipId[
                                                                            index]
                                                                        .toString()]!
                                                                .locationNames
                                                                .isEmpty
                                                            ? ''
                                                            : intershipMeta[
                                                                    intershipId[
                                                                            index]
                                                                        .toString()]!
                                                                .locationNames[
                                                                    0]
                                                                .toString())
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.02,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .play_circle_outline,
                                                          color: Colors
                                                              .grey.shade800,
                                                        ),
                                                        SizedBox(
                                                          width: width * 0.01,
                                                        ),
                                                        Text(
                                                          intershipMeta[
                                                                  intershipId[
                                                                          index]
                                                                      .toString()]!
                                                              .startDate
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                        SizedBox(
                                                          width: width * 0.08,
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .calendar_today_outlined,
                                                          color: Colors
                                                              .grey.shade800,
                                                        ),
                                                        SizedBox(
                                                          width: width * 0.02,
                                                        ),
                                                        Text(
                                                          intershipMeta[
                                                                  intershipId[
                                                                          index]
                                                                      .toString()]!
                                                              .duration
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              color: Colors
                                                                  .black87,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.02,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: width * 0.05,
                                                          height: height * 0.03,
                                                          child: Image(
                                                              fit: BoxFit.cover,
                                                              color: Colors.grey
                                                                  .shade700,
                                                              image: const AssetImage(
                                                                  'assets/images/money.png')),
                                                        ),
                                                        SizedBox(
                                                          width: width * 0.01,
                                                        ),
                                                        SizedBox(
                                                            width: width * 0.5,
                                                            height:
                                                                height * 0.03,
                                                            child: Text(
                                                              intershipMeta[intershipId[
                                                                          index]
                                                                      .toString()]!
                                                                  .stipend!
                                                                  .salary
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18),
                                                            )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.02,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .grey.shade300,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Text(
                                                          intershipMeta[
                                                                  intershipId[
                                                                          index]
                                                                      .toString()]!
                                                              .employmentType
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade900,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.02,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        intershipMeta[intershipId[index]
                                                                            .toString()]!
                                                                        .postedByLabel ==
                                                                    'Today' ||
                                                                intershipMeta[intershipId[index]
                                                                            .toString()]!
                                                                        .postedByLabel ==
                                                                    '1 day ago' ||
                                                                intershipMeta[intershipId[index]
                                                                            .toString()]!
                                                                        .postedByLabel ==
                                                                    '2 days ago' ||
                                                                intershipMeta[intershipId[index]
                                                                            .toString()]!
                                                                        .postedByLabel ==
                                                                    '3 days ago'
                                                            ? Container(
                                                                width:
                                                                    width * 0.3,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .lightGreenAccent
                                                                        .withOpacity(
                                                                            0.5),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .update,
                                                                        color: Colors
                                                                            .lightGreenAccent
                                                                            .shade700,
                                                                      ),
                                                                      SizedBox(
                                                                        width: width *
                                                                            0.01,
                                                                      ),
                                                                      Text(
                                                                        intershipMeta[intershipId[index].toString()]!
                                                                            .postedByLabel
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.lightGreenAccent.shade700,
                                                                            fontWeight: FontWeight.w400),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                width:
                                                                    width * 0.3,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5.0),
                                                                  child: Row(
                                                                    children: [
                                                                      const Icon(
                                                                          Icons
                                                                              .update),
                                                                      Text(
                                                                        intershipMeta[intershipId[index].toString()]!
                                                                            .postedByLabel
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.grey.shade900,
                                                                            fontWeight: FontWeight.w500),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                        Container(
                                                          width: width * 0.3,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .red.shade200,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.info,
                                                                  color: Colors
                                                                      .red
                                                                      .shade900,
                                                                ),
                                                                SizedBox(
                                                                  width: width *
                                                                      0.01,
                                                                ),
                                                                Text(
                                                                  intershipMeta[
                                                                          intershipId[index]
                                                                              .toString()]!
                                                                      .applicationDeadline
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red
                                                                          .shade900,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.02,
                                                    ),
                                                    const Divider(
                                                      thickness: 2,
                                                    ),
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 0, 5, 0),
                                                            child: Text(
                                                              'View details',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue
                                                                      .shade800,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 17),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                thickness: 10,
                                                color: Colors.grey.shade400,
                                              )
                                            ],
                                          )
                                        : SizedBox();
                                  }
                                }));
                          }))),
        ],
      ),
    );
  }
}
