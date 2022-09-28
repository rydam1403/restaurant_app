import 'package:flutter/material.dart';


class SearchForm extends StatefulWidget {
  SearchForm({this.onSearch});

  final void Function(String search)  onSearch ;

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formkey = GlobalKey<FormState>();
  var _autoValidate = false;
  var _search;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
            key: _formkey,
            autovalidate: _autoValidate,
            child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Enter Search',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  filled: true,
                  errorStyle: TextStyle(fontSize: 15),
                ),
                onChanged: (value) {
                  _search = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter a Search term';
                  }
                  return null;
                }
            )),
        SizedBox(
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width/3.0,
          child: RaisedButton(
            child: Text(
              'Search',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            color: Colors.red[500],
            onPressed: () {
              final isValid = _formkey.currentState.validate();
              if (isValid) {
                widget.onSearch(_search);
                FocusManager.instance.primaryFocus.unfocus();
              } else {
                setState(() {
                  _autoValidate = true;
                });
              }
            },
            elevation: 7.0,
          ),
        ),
      ],
    );
  }
}