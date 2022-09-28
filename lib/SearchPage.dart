import 'package:flutter/material.dart';
import 'package:restaurant_app/api.dart';
import 'package:restaurant_app/app_state.dart';
import 'search_form.dart';
import 'restaurant_item.dart';
import 'package:provider/provider.dart';
import 'search_filter_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  String query;

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<ZomatoApi>(context);
    final state = Provider.of<AppState>(context);

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Restaurant App', style: TextStyle(fontWeight: FontWeight.bold),),
            centerTitle: true,
            backgroundColor: Colors.red,
            actions: [
              InkWell(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchFilters()),
                  );
                },
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(
                    Icons.tune,
                  ),
                ),
              )
            ],
          ),
          body: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: SearchForm(
                    onSearch: (q){
                      setState(() {
                        query = q;
                      });
                    }
                )),
              query == null
                  ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.black12,
                        size: 110,
                      ),
                      Text(
                        'No results to display',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  )
              )
                  : FutureBuilder(
                future: api.searchRestaurants(query,state.searchOptions),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView(
                        children: snapshot.data.map<Widget>((json) => RestaurantItem(Restaurant(json))
                        ).toList(),
                      ),
                    );
                  }

                  return Text('Error retrieving results ${snapshot.error}');
                },
              ),
            ],
          ),
        ));
  }
}




