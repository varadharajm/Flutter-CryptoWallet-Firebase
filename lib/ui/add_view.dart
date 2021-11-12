import 'package:crypto_walle/net/flutterfire.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddView extends StatefulWidget {
  const AddView({Key? key}) : super(key: key);

  @override
  _AddViewState createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  List<String> coins = [
    "bitcoin",
    "tether",
    "ethereum",
  ];

  String dropdownValue  =  "bitcoin";
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton(
        value: dropdownValue,
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
          });
        },
        items: coins.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.3,
            child: TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                  labelText: 'Coin Amount',
              ),
            ),
          ),
          const SizedBox(height: 15.0,),
          Container(
            width: MediaQuery.of(context).size.width / 1.4,
            height: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.blue
            ),
              child: MaterialButton(
                onPressed: () async{
               await addCoins(dropdownValue, _amountController.text);
               Navigator.of(context).pop();
                },
                child: const Text("Add"),
              ),

          ),
        ],
      )
    );
  }
}
