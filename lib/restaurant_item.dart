import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RestaurantItem extends StatelessWidget{
  final Restaurant restaurant;

  RestaurantItem(this.restaurant);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            restaurant.thumbnail != null && restaurant.thumbnail.isNotEmpty
                ? Ink(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(restaurant.thumbnail)
                  )
              ),
            )
                : Container(
              height: 100,
              width: 100,
              color: Colors.blueGrey,
              child: Icon(
                Icons.restaurant,
                size: 30,
                color: Colors.white,
              ),
            ),
            Flexible(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0,),
                      Row(
                        children: [
                          Icon(Icons.location_on,color: Colors.red,size: 15,),
                          SizedBox(width: 5.0,),
                          Text(restaurant.locality),
                        ],
                      ),
                      SizedBox(height: 5.0,),
                      rate(s: restaurant.rating),
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}

rate({String s}) {
  return SmoothStarRating(
      allowHalfRating: true,
      starCount: 5,
      rating: double.parse(s),
      size: 18.0,
      isReadOnly: false,
      color: Colors.yellow,
      borderColor: Colors.grey,
      spacing: 0.0);
}

class Restaurant{
  final String name;
  final String address;
  final String rating;
  final int reviews;
  final String id;
  final String locality;
  final String thumbnail;

  Restaurant._({
    this.name,
    this.address,
    this.rating,
    this.reviews,
    this.id,
    this.locality,
    this.thumbnail,
  });
  factory Restaurant(Map json) => Restaurant._(
      name: json['restaurant']['name'],
      address: json['restaurant']['location']['address'],
      rating:
      json['restaurant']['user_rating']['aggregate_rating']?.toString(),
      reviews: json['restaurant']['all_reviews_count'],
      id: json['restaurant']['id'],
      locality: json['restaurant']['location']['locality'],
      thumbnail:
      json['restaurant']['featured_image'] ?? json['restaurant']['thumb']
  );

}