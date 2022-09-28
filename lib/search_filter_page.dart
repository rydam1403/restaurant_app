import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'api.dart';
import 'category.dart';

class SearchFilters extends StatefulWidget{
  @override
  _SearchFiltersState createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters>{

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<ZomatoApi>(context);
    final state = Provider.of<AppState>(context);

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Filter Your Search '),
              backgroundColor: Colors.red,
            ),
            body: Container(
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        api.categories is List<Categories>
                            ? Wrap(
                            spacing: 12,
                            children:
                            List<Widget>.generate(api.categories.length,(index){
                              final category = api.categories[index];
                              final isSelected = state.searchOptions.categories.contains(category.id);
                              return FilterChip(
                                label: Text(category.name),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context).textTheme.bodyText1.color,
                                  fontWeight: FontWeight.bold,
                                ),
                                selected: isSelected,
                                selectedColor: Colors.redAccent,
                                checkmarkColor: Colors.white,
                                onSelected: (bool selected) {
                                  setState(() {
                                    if(selected)
                                    {
                                      state.searchOptions.categories.add(category.id);
                                    }else{
                                      state.searchOptions.categories.remove(category.id);
                                    }
                                  });
                                },
                              );
                            })
                        )
                            : Center(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(),
                            )
                        ),
                        SizedBox(height: 30,),
                        Text(
                          'Location Type',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton<String>(
                            isExpanded: true,
                            value: state.searchOptions.location,
                            items: api.location.map<DropdownMenuItem<String>>(
                                  (value){
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            onChanged: (value){
                              setState(() {
                                state.searchOptions.location = value;
                              });
                            }),
                        SizedBox(height: 30,),
                        Text(
                          'Order By:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        for(int i=0;i<api.order.length;i++)
                          RadioListTile(
                              title: Text(api.order[i]),
                              value: api.order[i],
                              groupValue: state.searchOptions.order,
                              onChanged: (selection){
                                setState(() {
                                  state.searchOptions.order = selection;
                                });
                              }),
                        SizedBox(height: 30,),
                        Text(
                          'Sort Restaurant By:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Wrap(
                          spacing: 12,
                          children: api.sort.map<ChoiceChip>((sort){
                            return ChoiceChip(
                              label: Text(sort),
                              selected: state.searchOptions.sort == sort,
                              onSelected: (selected){
                                if(selected)
                                {
                                  setState(() {
                                    state.searchOptions.sort = sort;
                                  });
                                }
                              },
                            );
                          }).toList(),),
                        SizedBox(height: 30,),
                        Text(
                          'No. of results to show:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Slider(
                            value: state.searchOptions.count ?? 5,
                            min: 5,
                            max: api.count,
                            label: state.searchOptions.count?.round().toString(),
                            divisions: 3,
                            onChanged: (value){
                              setState(() {
                                state.searchOptions.count = value;
                              });
                            })
                      ],
                    ),
                  )
                ],
              ),
            )
        )
    );
  }
}

class SearchOptions{
  String location;
  String order;
  String sort;
  num count;
  List<int> categories = [];

  SearchOptions({this.location,this.order,this.sort,this.count});

  Map<String, dynamic> toJson() => {
    'entity_type': location,
    'sort': sort,
    'order': order,
    'count': count,
    'category': categories.join(',')
  };
}

