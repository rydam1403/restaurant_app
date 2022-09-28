import 'package:restaurant_app/category.dart';
import 'search_filter_page.dart';
import 'package:dio/dio.dart';


const xlocations = ['city','subzone','zone','landmark','metro','group'];
const xsort = ['cost','rating'];
const xorder = ['esc','desc'];
const double xcount = 20;

class ZomatoApi{
  final List<String> location = xlocations;
  final List<String> sort = xsort;
  final List<String> order = xorder;
  final double count = xcount;
  final Dio _dio;
  final List<Categories> categories = [];

  ZomatoApi(String key)
      : _dio = Dio(BaseOptions(
    baseUrl: 'https://developers.zomato.com/api/v2.1/',
    headers: {
      'user-key': key,
      'Accept': 'application/json',
    },
  ));


  Future loadCategories() async {
    final response = await _dio.get('categories');
    final data = response.data['categories'];
    categories.addAll( data.map<Categories>((json) => Categories (
      json['categories']['id'],
      json['categories']['name'],
    )));
  }

  Future<List> searchRestaurants(String query,SearchOptions options) async {
    final response = await _dio.get(
      'search',
      queryParameters: {
        'q': query,
        ...(options != null ? options.toJson() : {}),
      },
    );
    return response.data['restaurants'];
  }
}