import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hangman_app/utils.dart';

import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // AudioCache audioCache = AudioCache(prefix: 'sounds/');
  final player = AudioCache();
  String word = wordlist[Random().nextInt(wordlist.length)];
  List guessedalphabet = [];
  int points = 0;
  int status = 0;
  bool soundOn = true;
  List images = [
    'images/0.png',
    'images/1.png',
    'images/2.png',
    'images/3.png',
    'images/4.png',
    'images/5.png',
    'images/6.png',
    'images/7.png',
  ];

  playsound(String sound) async {
    if (soundOn) {
      await player.play(sound);
    }
  }

  opendialog(String title) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 200,
                decoration: const BoxDecoration(
                  // borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(113, 7, 255, 222),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 71, 71, 71),
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Your points: $points',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 71, 71, 71),
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'The word was: $word',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 249, 115, 26),
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              status = 0;
                              guessedalphabet.clear();
                              points = 0;
                              word =
                                  wordlist[Random().nextInt(wordlist.length)];
                            });
                            playsound('restart.mp3');
                          },
                          child: const Center(
                              child: Text(
                            'Play Again',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Color.fromARGB(36, 98, 95, 95),
                            ),
                          )),
                        ))
                  ],
                )),
          );
        });
  }

  String handleText() {
    String displayword = '';
    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      if (guessedalphabet.contains(char)) {
        // ignore: prefer_interpolation_to_compose_strings
        displayword += char + "";
      } else {
        displayword += '? ';
      }
    }

    return displayword;
  }

  checkletter(String alphabet) {
    if (word.contains(alphabet)) {
      setState(() {
        guessedalphabet.add(alphabet);
        points += 5;
      });
      playsound('correct.mp3');
    } else if (status != 6) {
      setState(() {
        status += 1;
        points -= 5;
      });
      playsound('wrong.mp3');
    } else {
      opendialog('Game Over!');
      playsound('youLose.mp3');
    }

    bool isWon = true;
    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      if (!guessedalphabet.contains(char)) {
        // ignore: prefer_interpolation_to_compose_strings
        setState(() {
          isWon = false;
        });
        break;
      }
    }
    if (isWon) {
      opendialog('Hurray, You Won!');
      playsound('youWon.mp3');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black45,
        title: const Text(
          'Hangman',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        actions: [
          IconButton(
            icon:
                Icon(soundOn ? Icons.volume_up_sharp : Icons.volume_off_sharp),
            color: Colors.purpleAccent,
            onPressed: () {
              setState(() {
                soundOn = !soundOn;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 3.5,
                decoration: const BoxDecoration(
                  color: Colors.lightBlueAccent,
                ),
                height: 30,
                child: Text('$points points',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              Image(
                width: 155,
                height: 155,
                image: AssetImage(images[status]),
                color: Colors.white,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 15,
              ),
              Text('${7 - status} lives left',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 23, 237, 201),
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(
                height: 30,
              ),
              Text(
                handleText(),
                style: const TextStyle(
                    fontSize: 35,
                    color: Colors.amber,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.2,
                children: letters.map((alphabet) {
                  return InkWell(
                    onTap: () => checkletter(alphabet),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          alphabet,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
