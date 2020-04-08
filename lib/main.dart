// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';


Future<CovidN> fetchCovidNational() async {
  final result = await http.get('https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-json/dpc-covid19-ita-andamento-nazionale.json');
  if (result.statusCode == 200) {
    return CovidN.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}


class CovidN {
  final String date;
  final int hospitalizedLow;
  final int intensiveCare;
  final int hospitalized;
  final int isolated;
  final int positive;
  final int deltaPositive;
  final int newPositive;
  final int recovered;
  final int deaths;
  final int total;
  final int swabs;
  final String yesterday;
  final int deltaHospitalizedLow;
  final int deltaIntensiveCare;
  final int deltaHospitalized;
  final int deltaIsolated;
  final int deltaNPositive;
  final int deltaDeltaPositive;
  final int deltaNewPositive;
  final int deltaRecovered;
  final int deltaDeaths;
  final int deltaTotal;
  final int deltaSwabs;
  
  CovidN({
    this.date,
    this.hospitalizedLow,
    this.intensiveCare,
    this.hospitalized, 
    this.isolated, 
    this.positive, 
    this.deltaPositive, 
    this.newPositive, 
    this.recovered, 
    this.deaths, 
    this.total, 
    this.swabs,
    this.yesterday,
    this.deltaHospitalizedLow,
    this.deltaIntensiveCare,
    this.deltaHospitalized,
    this.deltaIsolated,
    this.deltaNPositive,
    this.deltaDeltaPositive,
    this.deltaNewPositive,
    this.deltaRecovered,
    this.deltaDeaths,
    this.deltaTotal,
    this.deltaSwabs,
  });

  factory CovidN.fromJson(List<dynamic> json) {
    return CovidN(
      date: json[json.length-1]['data'].split("T")[0].split("-").reversed.join("/"),
      hospitalizedLow: json[json.length-1]['ricoverati_con_sintomi'],
      intensiveCare: json[json.length-1]['terapia_intensiva'],
      hospitalized: json[json.length-1]['totale_ospedalizzati'],
      isolated: json[json.length-1]['isolamento_domiciliare'],
      positive: json[json.length-1]['totale_positivi'],
      deltaPositive: json[json.length-1]['variazione_totale_positivi'],
      newPositive: json[json.length-1]['nuovi_positivi'],
      recovered: json[json.length-1]['dimessi_guariti'],
      deaths: json[json.length-1]['deceduti'],
      total: json[json.length-1]['totale_casi'],
      swabs: json[json.length-1]['tamponi'],
      yesterday: json[json.length-2]['data'].split("T")[0].split("-").reversed.join("/"),
      deltaHospitalizedLow: json[json.length-1]['ricoverati_con_sintomi'] - json[json.length-2]['ricoverati_con_sintomi'],
      deltaIntensiveCare: json[json.length-1]['terapia_intensiva'] - json[json.length-2]['terapia_intensiva'],
      deltaHospitalized: json[json.length-1]['totale_ospedalizzati'] - json[json.length-2]['totale_ospedalizzati'],
      deltaIsolated: json[json.length-1]['isolamento_domiciliare'] - json[json.length-2]['isolamento_domiciliare'],
      deltaNPositive: json[json.length-1]['totale_positivi'] - json[json.length-2]['totale_positivi'],
      deltaDeltaPositive: json[json.length-1]['variazione_totale_positivi'] - json[json.length-2]['variazione_totale_positivi'],
      deltaNewPositive: json[json.length-1]['nuovi_positivi'] - json[json.length-2]['nuovi_positivi'],
      deltaRecovered: json[json.length-1]['dimessi_guariti'] - json[json.length-2]['dimessi_guariti'],
      deltaDeaths: json[json.length-1]['deceduti'] - json[json.length-2]['deceduti'],
      deltaTotal: json[json.length-1]['totale_casi'] - json[json.length-2]['totale_casi'],
      deltaSwabs: json[json.length-1]['tamponi'] - json[json.length-2]['tamponi'],
    );
  }
}


class Region {
  String date;
  String name;
  int hospitalizedLow;
  int intensiveCare;
  int hospitalized;
  int isolated;
  int positive;
  int deltaPositive;
  int newPositive;
  int recovered;
  int deaths;
  int total;
  int swabs;

  Region({
    this.date,
    this.name,
    this.hospitalizedLow,
    this.intensiveCare,
    this.hospitalized, 
    this.isolated, 
    this.positive, 
    this.deltaPositive, 
    this.newPositive, 
    this.recovered, 
    this.deaths, 
    this.total, 
    this.swabs,
  });
}


Future getRegionsDetails() async {
  var result = await http.get('https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-json/dpc-covid19-ita-regioni-latest.json');
  if (result.statusCode == 200) {
    return result.body;
  }else{
    throw Exception('Failed to load data');
  }
}


Future getProvincesDetails() async {
  var result = await http.get('https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-json/dpc-covid19-ita-province-latest.json');
  if (result.statusCode == 200) {
    return result.body;
  }else{
    throw Exception('Failed to load data');
  }
}


void main() => runApp(CoVItaly());


class CoVItaly extends StatefulWidget {
  CoVItaly({Key key}) : super(key: key);

  @override
  _CoVItalyState createState() => _CoVItalyState();
}


class _CoVItalyState extends State<CoVItaly> {
  Future<CovidN> futureCovid;
  List<dynamic> provinces = List<dynamic>();
  @override
  void initState() {
    super.initState();
    futureCovid = fetchCovidNational();
  }


  Widget regionsWidget() {
    return FutureBuilder<dynamic>(
      builder: (context, snapshot) {
        if (snapshot.hasData){
          List<dynamic> regions = json.decode(snapshot.data);
          return ListView.builder(
            itemCount: regions.length,
            itemBuilder: (context, index) {
              String date = regions[index]['data'].split("T")[0].split("-").reversed.join("/");
              return Column(
                children: <Widget>[
                  ExpansionTile(
                    title: Text("${regions[index]['denominazione_regione']}"),
                    subtitle: Text(date),
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(bottom: 16.0, left: 16.0),
                        child: Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: 'Ricoverati: ${regions[index]['ricoverati_con_sintomi']}', style: TextStyle(fontWeight: FontWeight.normal)),
                                  TextSpan(text: '\nTerapia Intensiva: ${regions[index]['terapia_intensiva']}', style: TextStyle(fontWeight: FontWeight.normal)),
                                  TextSpan(text: '\nOspedalizzati: ${regions[index]['totale_ospedalizzati']}', style: TextStyle(fontWeight: FontWeight.normal)),
                                  TextSpan(text: '\nIn isolamento: ${regions[index]['isolamento_domiciliare']}', style: TextStyle(fontWeight: FontWeight.normal)),
                                  TextSpan(text: '\nAttualmente positivi: ${regions[index]['totale_positivi']}', style: TextStyle(fontWeight: FontWeight.normal)),
                                  TextSpan(text: '\nVariazione positivi: ${regions[index]['variazione_totale_positivi']}', style: TextStyle(fontWeight: FontWeight.normal)),
                                  TextSpan(text: '\nNuovi casi: ${regions[index]['nuovi_positivi']}', style: TextStyle(fontWeight: FontWeight.normal)),
                                  TextSpan(text: '\nGuariti/Dimessi: ${regions[index]['dimessi_guariti']}', style: TextStyle(fontWeight: FontWeight.normal)),
                                  TextSpan(text: '\nDeceduti: ${regions[index]['deceduti']}', style: TextStyle(fontWeight: FontWeight.normal)),
                                  TextSpan(text: '\nTotale casi: ${regions[index]['totale_casi']}', style: TextStyle(fontWeight: FontWeight.normal)),
                                  TextSpan(text: '\nTamponi effettuati: ${regions[index]['tamponi']}', style: TextStyle(fontWeight: FontWeight.normal)),
                                ],
                                style: TextStyle(height: 1.5,fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      )
                    ],

                  )
                ],
              );
            },
          );
        }else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
      future: getRegionsDetails(),
    );
  }


  Widget provincesWidget(){
    return FutureBuilder<dynamic>(
      builder: (context, snapshot) {
        if (snapshot.hasData){
          List<dynamic> p = json.decode(snapshot.data);
          p.removeWhere((dynamic item) => item['denominazione_provincia'] == "In fase di definizione/aggiornamento");
          return Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      List<dynamic> dummySearchList = List<dynamic>();
                      dummySearchList.addAll(p);
                      if(value.isNotEmpty && value != null) {
                        List<dynamic> dummyListData = List<dynamic>();
                        dummySearchList.forEach((item) {
                          if(item['denominazione_provincia'].toLowerCase().contains(value.toLowerCase())) {
                            dummyListData.add(item);
                          }
                        });
                        setState(() {
                          provinces.clear();
                          provinces.addAll(dummyListData);
                        });
                        return;
                      } else {
                        setState(() {
                          provinces.clear();
                          provinces.addAll(p);
                        });
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Inserisci il nome della provincia",
                        hintText: "Inserisci il nome della provincia",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: provinces.length,
                    itemBuilder: (context, index) {
                      String date = provinces[index]['data'].split("T")[0].split("-").reversed.join("/");
                      return Column(
                        children: <Widget>[
                          ListTile(
                            title: Text("${provinces[index]['denominazione_provincia']} (${provinces[index]['denominazione_regione']})"),
                            subtitle: Text("Totale Casi: ${provinces[index]['totale_casi']} in data ${date}"),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
      future: getProvincesDetails(),
    );
  }


  @override
  Widget build(BuildContext context) {
    print(MaterialLocalizations.of(context));
    return MaterialApp(
      title: 'CoVItaly 19',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: DefaultTabController(
        length: 4, 
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(icon: Icon(Icons.info_outline),),
                Tab(text: "Nazionale"),
                Tab(text: "Regionale"),
                Tab(text: "Provinciale"),
              ],
            ),
            title: Text('CoVItaly 19'),
          ),
          body: TabBarView(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "CoVItaly 19 è un\'applicazione open source creata col solo scopo di fornire i dati rilasciati dalla protezione civile ai cittadini italiani.\n\n\n",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                        children: [
                          TextSpan(
                            text: 'I dati di quest\'applicazione sono presi dalla ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'repository pubblica',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () { launch('https://github.com/pcm-dpc/COVID-19');
                            },
                          ),
                          TextSpan(
                            text: ' della Protezione Civile Italiana.\n\n',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: "Tutte le informazioni riguardante l'emergenza Coronavirus in Italia possono essere trovate sul "
                          ),
                          TextSpan(
                            text: "sito della Protezione Civile Italiana.",
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch("http://www.protezionecivile.it/attivita-rischi/rischio-sanitario/emergenze/coronavirus");
                              },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Column(
                  children: [
                    FutureBuilder<CovidN>(
                      future: futureCovid,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text.rich(
                            TextSpan(
                              text: 'Dati nazionali del giorno ${snapshot.data.date} rispetto al giorno ${snapshot.data.yesterday}:\n', // default text style
                              children: <TextSpan>[
                                TextSpan(text: '\nRicoverati: ${snapshot.data.hospitalizedLow} (${snapshot.data.deltaHospitalizedLow})', style: TextStyle(fontWeight: FontWeight.normal)),
                                TextSpan(text: '\nTerapia Intensiva: ${snapshot.data.intensiveCare} (${snapshot.data.deltaIntensiveCare})', style: TextStyle(fontWeight: FontWeight.normal)),
                                TextSpan(text: '\nOspedalizzati: ${snapshot.data.hospitalized} (${snapshot.data.deltaHospitalized})', style: TextStyle(fontWeight: FontWeight.normal)),
                                TextSpan(text: '\nIn isolamento: ${snapshot.data.isolated} (${snapshot.data.deltaIsolated})', style: TextStyle(fontWeight: FontWeight.normal)),
                                TextSpan(text: '\nAttualmente positivi: ${snapshot.data.positive} (${snapshot.data.deltaNPositive})', style: TextStyle(fontWeight: FontWeight.normal)),
                                TextSpan(text: '\nVariazione positivi: ${snapshot.data.deltaPositive} (${snapshot.data.deltaDeltaPositive})', style: TextStyle(fontWeight: FontWeight.normal)),
                                TextSpan(text: '\nNuovi casi: ${snapshot.data.newPositive} (${snapshot.data.deltaNewPositive})', style: TextStyle(fontWeight: FontWeight.normal)),
                                TextSpan(text: '\nGuariti/Dimessi: ${snapshot.data.recovered} (${snapshot.data.deltaRecovered})', style: TextStyle(fontWeight: FontWeight.normal)),
                                TextSpan(text: '\nDeceduti: ${snapshot.data.deaths} (${snapshot.data.deltaDeaths})', style: TextStyle(fontWeight: FontWeight.normal)),
                                TextSpan(text: '\nTotale casi: ${snapshot.data.total} (${snapshot.data.deltaTotal})', style: TextStyle(fontWeight: FontWeight.normal)),
                                TextSpan(text: '\nTamponi effettuati: ${snapshot.data.swabs} (${snapshot.data.deltaSwabs})', style: TextStyle(fontWeight: FontWeight.normal)),
                              ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }

                        // By default, show a loading spinner.
                        return CircularProgressIndicator();
                      },
                    ),
                  ],
                )
              ),
              regionsWidget(),
              provincesWidget(),
            ],
          )
        ),
      )
    );
  }
}