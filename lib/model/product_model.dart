import 'package:cloud_firestore/cloud_firestore.dart';

class Product{
  int price;
  String name;
  String description;
  String id;
  String url;
  

  Product({this.price, this.name, this.description, this.id, this.url});

  Product.fromMap(Map<String, dynamic> data){
    id = data['id'];
    name = data['name'];
    price = data['price'];
    description = data['description'];
    url = data['url'];
  }
  //SENDING data to our server
  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'url': url,
    };
  }
}