import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_walle/net/api_methods.dart';
import 'package:crypto_walle/net/flutterfire.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double bitcoin =  0.0;
  double ethereum = 0.0;
  double tether = 0.0;

  @override
  void initState(){
    getValues();
  }
  getValues() async {
    bitcoin = (await getPrice('bitcoin'))!;
    ethereum = (await getPrice('ethereum'))!;
    tether = (await getPrice('tether'))!;
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    getValues(String id, double amount){
      if (id == "bitcoin"){
        return bitcoin * amount;
      }else if(id == "ethereum") {
        return ethereum * amount;
      }if(id == "tether" ){
        return tether * amount;
      }
    }
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('Coins')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
              return ListView(
                children: snapshot.data!.docs.map((document) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 15.0, right: 15.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height /12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.blue,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(width: 5.0, height: 0.0,),
                          Text("Coin : ${document.id}",
                            style: const TextStyle(color: Colors.white, fontSize: 18.0),),
                          Text("₹ ${getValues(document.id,document['Amount'])!.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.white, fontSize: 18.0),),
                          IconButton(onPressed: () async{
                            await removeCoins(document.id);
                          },
                              icon: const Icon(Icons.clear,color: Colors.red,)),
                        ],
                      )),
                  );
                }).toList(),
              );
            }),
          ),
        ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddView()));},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add,
      color: Colors.white,),),
    );
  }
}

