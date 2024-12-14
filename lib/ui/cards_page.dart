import 'package:card_holder/core/const/cards.dart';
import 'package:card_holder/ui/widgets/card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'card_page.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffeff0f2),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffeff0f2),
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: const Color(0xffeff0f2),
            centerTitle: false,
            title: const Text(
              'Select card',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(8),
                  child: const Row(
                    children: [
                      Icon(Icons.add),
                      Text(
                        'New card',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (BuildContext context, int index) {
                return CardWidget(
                  owner: cards[index].owner,
                  balance: cards[index].balance.toString(),
                  cardNumber: cards[index].number,
                  main: index == 1 ? true : false,
                  color: cards[index].color,
                  gradient: cards[index].gradient,
                  ontap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => CardPage(
                          cardModel: cards[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
