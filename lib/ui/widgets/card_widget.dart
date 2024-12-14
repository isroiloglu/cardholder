import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.owner,
    required this.balance,
    required this.cardNumber,
    required this.main,
    required this.ontap,
    this.color,
    this.gradient,
    this.image,
    this.blur,
  });

  final String owner;
  final Color? color;
  final List<Color>? gradient;
  final String? image;
  final String balance;
  final String cardNumber;
  final bool main;
  final double? blur;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    String type = '';
    String value = cardNumber.substring(0, 4);
    String number = cardNumber.substring(11, 15);
    log('VALUE IS $value');
    log('VISA IS ${value.startsWith('4')}');
    log('MASTERCARD IS ${value.startsWith('51')}\n');
    if (value.startsWith('4')) {
      type = 'visa';
    } else if (value.startsWith('51') ||
        value.startsWith('52') ||
        value.startsWith('53') ||
        value.startsWith('54') ||
        value.startsWith('55')) {
      type = 'mastercard';
    } else {
      switch (value) {
        case '8600':
          type = 'uzcard';
          break;
        case '5614':
          type = 'uzcard';
          break;
        case '9860':
          type = 'humo';
          break;
        default:
          type = '';
      }
    }

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: ontap,
        child: Container(
          // margin: EdgeInsets.only(bottom: 16),

          width: double.infinity,

          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              image: image != null
                  ? DecorationImage(
                      image: FileImage(File(image!)), fit: BoxFit.cover)
                  : null,
              gradient: gradient != null
                  ? LinearGradient(
                      colors: gradient!,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)
                  : null),
          height: MediaQuery.of(context).size.height / 4.5,
          child: Stack(
            children: [
              if (image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blur ?? 5.0,
                      sigmaY: blur ?? 5.0,
                    ),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height / 4.5,
                        width: double.infinity),
                  ),
                ),
              if (image == null)
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'zpay',
                        style: TextStyle(
                            fontSize: 60,
                            color: Colors.black.withOpacity(0.1),
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, left: 16, bottom: 8, right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              owner,
                              style: TextStyle(
                                fontSize: 16,
                                shadows: [
                                  if (image != null)
                                    const BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 1,
                                      offset: Offset(1, 1),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              '\$$balance',
                              style: TextStyle(
                                fontSize: 20,
                                shadows: [
                                  if (image != null)
                                    const BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 1,
                                      offset: Offset(1, 1),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        cardIcon(type)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '****' + number,
                          style: TextStyle(
                            fontSize: 14,
                            shadows: [
                              if (image != null)
                                const BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 1,
                                  offset: Offset(1, 1),
                                ),
                            ],
                          ),
                        ),
                        if (main)
                          Container(
                            // margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.all(6),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'Main card',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    shadows: [
                                      if (image != null)
                                        const BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 1,
                                          offset: Offset(1, 1),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardIcon(String type) {
    String t = type.toLowerCase();
    String icon = '';
    switch (t) {
      case "humo":
        icon = 'assets/images/humo.svg';
        break;
      case 'uzcard':
        icon = 'assets/images/uzcard.svg';
        break;
      case 'visa':
        icon = 'assets/images/visa.svg';
        break;
      case 'mastercard':
        icon = 'assets/images/master.svg';
        break;
    }
    return SvgPicture.asset(
      icon,
      fit: BoxFit.contain,
    );
  }
}
