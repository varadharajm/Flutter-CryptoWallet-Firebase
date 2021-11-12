//https://api.coingecko.com/api/v3/coins/

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<double?> getPrice(String id ) async {
  try {
    var url = "https://api.coingecko.com/api/v3/coins/"+id;
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    var value = json['market_data']['current_price']['inr'].toString();
    return double.parse(value,);
  }catch (e){
    log(e.toString());
    // return
  }
}

// Future<String> coinList() async{
//   try{
//     var url = "https://api.coingecko.com/api/v3/coins/";
//     var response = await http.get(Uri.parse(url));
//     var json = jsonDecode(response.body);
//     var value = json.toString();
//     return value;
//   }catch(e){ log(e.toString());}
// }