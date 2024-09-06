import 'package:flutter/material.dart';
import 'package:calculator/buttonele.dart' as ele;
import 'package:math_expressions/math_expressions.dart';
// import 'package:calculator/buttoncustom.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final buttonele = ele.Button.buttonele;
  String input = "";
  String output = "";

  void resetDisplay() {
    setState(() {
      input = "";
      output = "";
    });
  }

  void evaluate() {
    String lastchar = input[input.length - 1];
    if (!chkoperator(lastchar)) {
      String eval = input;
      eval = eval.replaceAll('x', '*');
      Parser parserobj = Parser();

      Expression expobj = parserobj.parse(eval);
      ContextModel cm = ContextModel();

      double evalres = expobj.evaluate(EvaluationType.REAL, cm);
      setState(() {
        if (evalres == evalres.toInt()) {
          output = evalres.toInt().toString();
        } else {
          output = evalres.toString();
        }
      });
    }
  }

  bool chkoperator(String n) {
    if (n == "/" || n == "x" || n == "-" || n == "+" || n == "=") {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculator',
          style: TextStyle(color: Color(0xFF45CE30)),
        ),
        centerTitle: true,
      ),
      body: Column(children: [
        Container(
          color: Colors.black,
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                height: 65,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  children: [
                    Text(
                      input,
                      style: const TextStyle(fontSize: 44, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                output,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
        Expanded(
            flex: 2,
            child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: buttonele.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Buttoncustom(
                          tap: () {
                            resetDisplay();
                          },
                          colour: const Color(0xFF9EA3A7),
                          text: buttonele[index],
                          textColor: Colors.black,
                        );
                      } else if (index == 1) {
                        return Buttoncustom(
                          tap: () {
                            setState(() {
                              input = input + buttonele[index];
                            });
                          },
                          colour: const Color(0xFF9EA3A7),
                          text: buttonele[index],
                          textColor: Colors.black,
                        );
                      } else if (index == 2) {
                        return Buttoncustom(
                          tap: () {
                            setState(() {
                              if (input.isNotEmpty) {
                                input = input.substring(0, (input.length - 1));
                              }
                            });
                          },
                          colour: const Color(0xFF9EA3A7),
                          text: buttonele[index],
                          textColor: Colors.black,
                        );
                      } else if (index == 19) {
                        return Buttoncustom(
                          tap: () {
                            evaluate();
                          },
                          colour: const Color(0xFF45CE30),
                          text: buttonele[index],
                          textColor: Colors.black,
                        );
                      } else {
                        return Buttoncustom(
                          tap: () {
                            if (output == '') {
                              setState(() {
                                input += buttonele[index];
                              });
                            } else {
                              if (chkoperator(buttonele[index])) {
                                input = output + buttonele[index];
                                output = '';
                              } else {
                                input = '';
                                output = '';
                                input += buttonele[index];
                              }

                              setState(() {});
                            }
                          },
                          colour: chkoperator(buttonele[index])
                              ? const Color(0xFF01CBC6)
                              : const Color(0xFF333333),
                          text: buttonele[index],
                          textColor: chkoperator(buttonele[index])
                              ? Colors.black
                              : Colors.white,
                        );
                      }
                    })))
      ]),
    );
  }
}

class Buttoncustom extends StatefulWidget {
  const Buttoncustom(
      {super.key,
      required this.tap,
      required this.colour,
      required this.text,
      required this.textColor});

  final VoidCallback tap;
  final Color colour;
  final String text;
  final Color textColor;

  @override
  State<Buttoncustom> createState() => _ButtoncustomState();
}

class _ButtoncustomState extends State<Buttoncustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: widget.tap,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.colour,
          foregroundColor: widget.textColor,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(30.0), // Adjust the radius as needed
          ),
        ),
        child: Center(
            child: Text(
          widget.text,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
        )),
      ),
    );
  }
}
