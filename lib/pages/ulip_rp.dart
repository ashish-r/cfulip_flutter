import 'dart:convert';

import 'package:cfulip_flutter/models/ulip_quotes_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UlipRp extends StatefulWidget {
  final String quoteId;
  UlipRp(this.quoteId);
  @override
  State<StatefulWidget> createState() {
    return _UlipRpState();
  }
}

class _UlipRpState extends State<UlipRp> {
  bool _isLoading = true;
  List<UlipQuotesData> quotes;
  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future<dynamic> _getData() {
    print('get data');
    return http
        .post('https://qa.coverfox.com/ulip-insurance/api/get_plans',
            body: json.encode(
                {'quoteId': widget.quoteId, 'sales_channel': 'coverfox'}))
        .then((http.Response response) {
      print('response recieved');
      List<dynamic> dataList = json.decode(response.body);
      quotes = dataList
          .map((data) => UlipQuotesData(
              insurerName: data['insurerName'],
              planName: data['planName'],
              maturityAmountAtPerformance:
                  data['maturityAmountAtPerformance'].toDouble(),
              pastPerformance: data['pastPerformance'] == null
                  ? null
                  : data['pastPerformance'].toDouble()))
          .toList();
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget _buildQuoteCard(BuildContext context, int index) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                FadeInImage(
                  image: NetworkImage(
                      'https://qa.coverfox.com/ulip-insurance/static/images/insurer/' +
                          quotes[index].insurerName +
                          '.png'),
                  height: 50.0,
                  width: 125.0,
                  placeholder: AssetImage('assets/images/loader.gif'),
                  fit: BoxFit.fitWidth,
                ),
                Expanded(
                  child: Container(
                    child: Column(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(child: Text(quotes[index].planName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0,),),),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Maturity Amount  ', style: TextStyle(fontSize: 11.0, color: Colors.grey, fontWeight: FontWeight.bold,),),
                          Text((quotes[index].maturityAmountAtPerformance/100000).toStringAsFixed(2) + ' Lakhs', style: TextStyle(fontSize: 16.0),),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(quotes[index].pastPerformance == null
                          ? ''
                          : 'Past Performance @ ', style: TextStyle(fontSize: 9.0, color: Colors.grey, fontWeight: FontWeight.bold,),),
                          Text(quotes[index].pastPerformance == null
                          ? ''
                          : quotes[index].pastPerformance.toString(), style: TextStyle(fontSize: 11.0, color: Colors.grey, fontWeight: FontWeight.bold,),),
                        ],
                      ),
                    ],
                  ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quotesList() {
    return _isLoading
        ? Center(
            child: SizedBox(
            child: CircularProgressIndicator(),
            height: 75.0,
            width: 75.0,
          ))
        : ((quotes == null || quotes.length < 1)
            ? Center(child: Text('No Quote Found'))
            : (Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Results',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: quotes.length,
                        itemBuilder: _buildQuoteCard,
                      ),
                    ),
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes'),
      ),
      body: Container(
        child: RefreshIndicator(
          child: _quotesList(),
          onRefresh: _getData,
        ),
      ),
    );
  }
}
