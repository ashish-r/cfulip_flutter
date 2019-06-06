import 'dart:convert';
import 'package:cfulip_flutter/models/ulip_qf_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class UlipQf extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UlipQfState();
  }
}

class _UlipQfState extends State<UlipQf> {
  String _investmentType;
  int _investmentAmount;
  String _investFor;
  String _withdrawAfter;
  int _planType;
  String _age;
  String _incomeId;
  int _mobile;
  bool _formLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _investmentTypeDropDown() {
    List<Map<String, String>> investmentTypeMap = const [
      {'type': 'Monthly', 'value': 'M'},
      {'type': 'Yearly', 'value': 'Y'},
      {'type': 'Lumpsum', 'value': 'S'}
    ];
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            errorText: state.hasError ? state.errorText : null,
          ),
          isEmpty: _investmentType == null || _investmentType.isEmpty,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _investmentType,
              hint: Text('Select Invesment Type'),
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _investmentType = newValue;
                  state.didChange(newValue);
                });
              },
              items: investmentTypeMap.map<DropdownMenuItem<String>>(
                  (Map<String, String> investmentType) {
                return DropdownMenuItem<String>(
                  value: investmentType['value'],
                  child: Text(investmentType['type']),
                );
              }).toList(),
            ),
          ),
        );
      },
      validator: (val) {
        return val == null || val.isEmpty
            ? 'Please select Investment Type'
            : null;
      },
    );
  }

  Widget _withdrawAfterDropDown() {
    int investFor = int.tryParse(_investFor == null ? '5' : _investFor);
    List<int> withdrawAfterMap = List<int>.filled(31 - investFor, 0)
        .asMap()
        .map<int, int>((int k, int v) {
          return MapEntry(k, k + investFor);
        })
        .values
        .toList();

    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            errorText: state.hasError ? state.errorText : null,
          ),
          isEmpty: _withdrawAfter == null || _withdrawAfter.isEmpty,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _withdrawAfter,
              hint: Text('Select Withdraw After'),
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _withdrawAfter = newValue;
                  state.didChange(newValue);
                });
              },
              items: withdrawAfterMap.map<DropdownMenuItem<String>>((int year) {
                return DropdownMenuItem<String>(
                  value: year.toString(),
                  child: Text('$year Years'),
                );
              }).toList(),
            ),
          ),
        );
      },
      validator: (val) {
        return val == null || val.isEmpty
            ? 'Please select Withdraw After'
            : null;
      },
    );
  }

  Widget _ageDropDown() {
    List<int> ageList = List<int>.filled(53, 0)
        .asMap()
        .map<int, int>((int k, int v) {
          return MapEntry(k, k + 18);
        })
        .values
        .toList();

    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            errorText: state.hasError ? state.errorText : null,
          ),
          isEmpty: _age == null || _age.isEmpty,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _age,
              hint: Text('Select Age'),
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _age = newValue;
                  state.didChange(newValue);
                });
              },
              items: ageList.map<DropdownMenuItem<String>>((int year) {
                return DropdownMenuItem<String>(
                  value: year.toString(),
                  child: Text('$year Years'),
                );
              }).toList(),
            ),
          ),
        );
      },
      validator: (val) {
        return val == null || val.isEmpty ? 'Please select Age ' : null;
      },
    );
  }

  Widget _investForDropDown() {
    int withdrawAfter =
        int.tryParse(_withdrawAfter == null ? '30' : _withdrawAfter);
    List<int> investForMap = List<int>.filled(withdrawAfter - 4, 0)
        .asMap()
        .map<int, int>((int k, int v) {
          return MapEntry(k, k + 5);
        })
        .values
        .toList();

    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            errorText: state.hasError ? state.errorText : null,
          ),
          isEmpty: _investFor == null || _investFor.isEmpty,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _investFor,
              hint: Text('Select Investment For'),
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _investFor = newValue;
                  state.didChange(newValue);
                });
              },
              items: investForMap.map<DropdownMenuItem<String>>((int year) {
                return DropdownMenuItem<String>(
                  value: year.toString(),
                  child: Text('$year Years'),
                );
              }).toList(),
            ),
          ),
        );
      },
      validator: (val) {
        return val == null || val.isEmpty ? 'Please select Invest For' : null;
      },
    );
  }

  Widget _salaryRangeDropDown() {
    List<Map<String, String>> salarayRangeList = const [
      {'key': '0', 'value': 'Less than 2 lakh'},
      {'key': '1', 'value': '2 - 5 lakh'},
      {'key': '2', 'value': '5 - 8 lakh'},
      {'key': '3', 'value': '8 - 12 lakh'},
      {'key': '4', 'value': '12 - 15 lakh'},
      {'key': '5', 'value': 'More than 15 lakh'},
    ];

    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            errorText: state.hasError ? state.errorText : null,
          ),
          isEmpty: _incomeId == null || _incomeId.isEmpty,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _incomeId,
              hint: Text('Select Income Range'),
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _incomeId = newValue;
                  state.didChange(newValue);
                });
              },
              items: salarayRangeList.map<DropdownMenuItem<String>>(
                  (Map<String, String> salaryRange) {
                return DropdownMenuItem<String>(
                  value: salaryRange['key'],
                  child: Text(salaryRange['value']),
                );
              }).toList(),
            ),
          ),
        );
      },
      validator: (val) {
        return val == null || val.isEmpty ? 'Please select Invest For' : null;
      },
    );
  }

  Widget _investmentAmountField() {
    return TextFormField(
      style: TextStyle(
        height: 1.0,
      ),
      inputFormatters: [LengthLimitingTextInputFormatter(10)],
      decoration: InputDecoration(
        hintText: 'Enter Investment Amount',
        hintStyle: TextStyle(
          height: 0.5,
        ),
      ),
      keyboardType: TextInputType.number,
      initialValue:
          _investmentAmount == null ? '' : _investmentAmount.toString(),
      validator: (val) {
        int valInt = int.tryParse(val);
        if (valInt == null) {
          return 'Investment Amount Is Required';
        }
        if (valInt > 10000000) {
          return 'Maximum Amount is 1,00,00,000';
        }
        if (_investmentType != null && _investmentType.isNotEmpty) {
          if (_investmentType == 'M' && valInt < 1000) {
            return 'Minimum Amount Is 1,000 for Monthly Policy';
          }
          if (_investmentType == 'Y' && valInt < 12000) {
            return 'Minimum Amount Is 12,000 for Annual Policy';
          }
          if (_investmentType == 'S' && valInt < 25000) {
            return 'Minimum Amount Is 25,000 For Lumpsum policy';
          }
        }
        return null;
      },
      onSaved: (String value) {
        _investmentAmount = int.tryParse(value);
      },
    );
  }

  Widget _mobileNumberField() {
    return TextFormField(
      style: TextStyle(
        height: 1.0,
      ),
      inputFormatters: [LengthLimitingTextInputFormatter(10)],
      decoration: InputDecoration(
        labelText: 'Mobile Number',
        hintText: '10 Digit Mobile Number',
        hintStyle: TextStyle(
          height: 0.5,
        ),
      ),
      keyboardType: TextInputType.phone,
      initialValue: _mobile == null ? '' : _mobile.toString(),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Mobile Number Is Required';
        }
        if (val.length != 10) {
          return 'Mobile Number Must be of 10 digits';
        }
        return null;
      },
      onSaved: (String value) {
        _mobile = int.tryParse(value);
      },
    );
  }

  Widget _investTypeRadio() {
    String guaranteedPlanInfo =
        'Irrespective of the market behaviour guaranteed return of about 5% - 8%';
    String marketLinkedPlanInfo =
        'Based on market fluctuations, typically between 12% - 18%';
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none,
            helperText: _planType == 0
                ? marketLinkedPlanInfo
                : (_planType == 1 ? guaranteedPlanInfo : ''),
            errorText: state.hasError ? state.errorText : null,
          ),
          isEmpty: _planType == null,
          child: Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Radio(
                    value: 0,
                    groupValue: _planType,
                    onChanged: (int newValue) {
                      setState(() {
                        _planType = newValue;
                        state.didChange('0');
                      });
                    },
                  ),
                  Text(
                    'Market Linked Plans',
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                    value: 1,
                    groupValue: _planType,
                    onChanged: (int newValue) {
                      setState(() {
                        _planType = newValue;
                        state.didChange('1');
                      });
                    },
                  ),
                  Text(
                    'Guaranteed Plans',
                  ),
                ],
              )
            ],
          ),
        );
      },
      validator: (val) {
        return val == null ? 'Please select Plan Type' : null;
      },
    );
  }

  void _submitForm() {
    final FormState formState = _formKey.currentState;
    print(formState.validate());
    if (formState.validate()) {
      formState.save();
      setState(() {
        _formLoading = true;
      });
      final UlipQfData apiData = UlipQfData(
        age: int.tryParse(_age),
        income: int.tryParse(_incomeId),
        mobile: _mobile,
        PT: int.tryParse(_withdrawAfter),
        PPT: int.tryParse(_investFor),
        investmentAmount: _investmentAmount,
        investmentFrequency: _investmentType,
        planType: _planType,
      );

      print(apiData.toJSON());

      http
          .post('https://qa.coverfox.com/ulip-insurance/api/create_quote',
              body: apiData.toJSON())
          .then((http.Response response) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        setState(() {
          _formLoading = false;
        });
        if (data['status']) {
          Navigator.pushNamed(context, '/ulipRp/' + data['quoteId']);
        } else {
          throw 'something went wrong';
        }
      }).catchError((error) {
        setState(() {
          _formLoading = false;
        });
        print(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: SingleChildScrollView(
        child: Container(
          width: targetWidth,
          child: Form(
            key: _formKey,
            autovalidate: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Center(
                    child: Text(
                  'Investment Form',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                )),
                SizedBox(
                  height: 30.0,
                ),
                Text('Investment Type'),
                _investmentTypeDropDown(),
                SizedBox(
                  height: 10.0,
                ),
                Text('Investment Amount'),
                _investmentAmountField(),
                SizedBox(
                  height: 10.0,
                ),
                Text('Investment For'),
                _investForDropDown(),
                SizedBox(
                  height: 10.0,
                ),
                Text('Withdraw After'),
                _withdrawAfterDropDown(),
                SizedBox(
                  height: 10.0,
                ),
                Text('Plan Type'),
                _investTypeRadio(),
                Text('Salary Range'),
                _salaryRangeDropDown(),
                SizedBox(
                  height: 10.0,
                ),
                Text('Age'),
                _ageDropDown(),
                SizedBox(
                  height: 10.0,
                ),
                Text('Mobile Number'),
                _mobileNumberField(),
                SizedBox(
                  height: 40.0,
                ),
                Center(
                  child: ButtonTheme(
                    minWidth: 200.0,
                    height: 50.0,
                    child: RaisedButton(
                      color: Theme.of(context).buttonColor,
                      textColor: Theme.of(context).accentColor,
                      child: _formLoading
                          ? SizedBox(
                              child: CircularProgressIndicator(),
                              height: 20.0,
                              width: 20.0,
                            )
                          : Text('VIEW QUOTES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0,),),
                      onPressed: _formLoading ? () {} : _submitForm,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
