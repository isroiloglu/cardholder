import 'dart:io';

import 'package:card_holder/core/const/colors.dart';
import 'package:card_holder/core/models/card_model.dart';
import 'package:card_holder/ui/cards_page.dart';
import 'package:card_holder/ui/widgets/card_widget.dart';
import 'package:card_holder/ui/widgets/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/bloc/card_bloc.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key, required this.cardModel});

  final CardModel cardModel;

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  Color? colorS;
  List<Color>? gradientS;
  String? fileS;

  double blur = 0;
  bool save = false;

  double red = 0;
  double green = 0;
  double blue = 255;

  CardBloc bloc = CardBloc();

  @override
  void initState() {
    colorS = widget.cardModel.color;
    gradientS = widget.cardModel.gradient;
    fileS = widget.cardModel.image;
    super.initState();
  }

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
            centerTitle: true,
            title: const Text(
              'Edit card',
              style: TextStyle(fontSize: 16),
            ),
          ),
          body: SingleChildScrollView(
            child: BlocProvider.value(
              value: bloc,
              child: BlocConsumer<CardBloc, CardState>(
                listener: (context, state) {
                  if (state is CardSaved) {
                    Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                const CardsPage()),
                        (Route<dynamic> route) => false);
                  }
                  if (state is CardError) {
                    SnackBar snackBar = const SnackBar(
                      content: Text(
                        'Saqlashda xatolik,qayta urinib ko\'ring',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.redAccent,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                builder: (context, state) {
                  if (state is CardLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CardWidget(
                          owner: widget.cardModel.owner,
                          gradient: gradientS,
                          color: colorS,
                          image: fileS,
                          balance: widget.cardModel.balance.toString(),
                          cardNumber: widget.cardModel.number,
                          main: false,
                          blur: blur,
                          ontap: () {},
                        ),
                      ),
                      if (fileS != null) const SizedBox(height: 32),
                      if (fileS != null)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Set blur to background',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      if (fileS != null) const SizedBox(height: 8),
                      if (fileS != null)
                        Slider(
                          value: blur,
                          min: 0,
                          max: 20,
                          activeColor: const Color(0xff3B82F6),
                          onChanged: (value) {
                            setState(() {
                              blur = value;
                            });
                          },
                        ),
                      const SizedBox(height: 32),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Select color ',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 75,
                        child: ListView.builder(
                          itemCount: colors.length + 1,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                if (index == 0) {
                                  pickColor(context);
                                } else {
                                  setState(() {
                                    if (save == false) {
                                      save = true;
                                    }
                                    gradientS = null;
                                    fileS = null;
                                    colorS = colors[index - 1];
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                margin: EdgeInsets.only(
                                    left: 12,
                                    right: index == colors.length ? 12 : 0),
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == 0
                                      ? Colors.white
                                      : colors[index - 1],
                                ),
                                child: index == 0
                                    ? Image.asset(
                                        'assets/images/palette.png',
                                        height: 50,
                                        width: 50,
                                      )
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Select gradient ',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 75,
                        child: ListView.builder(
                          itemCount: gradients.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (save == false) {
                                    save = true;
                                  }

                                  colorS = null;
                                  fileS = null;
                                  gradientS = gradients[index];
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 12,
                                    right:
                                        index == gradients.length - 1 ? 12 : 0),
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        colors: gradients[index],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight)),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      InkWell(
                        onTap: () {
                          CustomCameraDialog.show(
                            context,
                            compressQuality: 50,
                            callback: (file) {
                              setState(() {
                                if (save == false) {
                                  save = true;
                                }

                                colorS = null;
                                gradientS = null;
                                fileS = file.path;
                              });
                            },
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 32, horizontal: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/image-gallery.png',
                                height: 50,
                                width: 50,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Select image for background',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 80),
                    ],
                  );
                },
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: save
              ? FloatingActionButton.extended(
                  onPressed: () {
                    bloc.add(SavePressed(
                        model: CardModel(
                      id: widget.cardModel.id,
                      owner: widget.cardModel.owner,
                      balance: widget.cardModel.balance,
                      number: widget.cardModel.number,
                      color: colorS,
                      gradient: gradientS,
                      image: fileS,
                      blur: blur,
                    )));
                  },
                  label: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/diskette.png',
                        height: 25,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Save',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                )
              : null,
        ),
      ),
    );
  }

  void pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Pick a color!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildColorSlider('Red', red, Colors.red, (value) {
                  setDialogState(() {
                    red = value;
                  });
                  setState(() {
                    if (save == false) {
                      save = true;
                    }

                    if (gradientS != null) {
                      gradientS = null;
                    }
                    if (fileS != null) {
                      fileS = null;
                    }
                    colorS = Color.fromRGBO(
                      red.toInt(),
                      green.toInt(),
                      blue.toInt(),
                      1,
                    );
                  });
                }),
                buildColorSlider('Green', green, Colors.green, (value) {
                  setDialogState(() {
                    green = value;
                  });
                  setState(() {
                    if (save == false) {
                      save = true;
                    }

                    if (gradientS != null) {
                      gradientS = null;
                    }
                    if (fileS != null) {
                      fileS = null;
                    }
                    colorS = Color.fromRGBO(
                      red.toInt(),
                      green.toInt(),
                      blue.toInt(),
                      1,
                    );
                  });
                }),
                buildColorSlider('Blue', blue, Colors.blue, (value) {
                  setDialogState(() {
                    blue = value;
                  });
                  setState(() {
                    if (save == false) {
                      save = true;
                    }
                    if (gradientS != null) {
                      gradientS = null;
                    }
                    if (fileS != null) {
                      fileS = null;
                    }
                    colorS = Color.fromRGBO(
                      red.toInt(),
                      green.toInt(),
                      blue.toInt(),
                      1,
                    );
                  });
                }),
                const SizedBox(height: 16),
                Container(
                  width: 100,
                  height: 35,
                  color: colorS,
                ),
                const SizedBox(height: 16),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Done'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildColorSlider(
      String label, double value, Color color, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toInt()}'),
        Slider(
          value: value,
          min: 0,
          max: 255,
          activeColor: color,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
