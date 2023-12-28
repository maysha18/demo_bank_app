import 'package:demo_project/models/demo_model.dart';
import 'package:demo_project/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  Map<String, dynamic> answers = {};
  int selectedCityIndex = -1;
  int selectedstateIndex = -1;
  TextEditingController totalFamilyIncome = TextEditingController();
  String fieldName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalFamilyIncome.addListener(() {
      _saveValueOfController();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    totalFamilyIncome.dispose();
  }

  DemoController getRef() {
    return ref.read(demoControllerNotifier.notifier);
  }

  _saveValueOfController() {
    setState(() {
      answers[fieldName] = totalFamilyIncome.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = AppBar().preferredSize.height;
    var currentQues = ref.watch(questionNoProvider);
    var questions = getRef().questions;
    var demoModel = getRef().demoModel;

    return Scaffold(
      body: (currentQues < getRef().questions.length)
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height,
                    ),
                    Text(
                      demoModel!.title!,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StepProgressIndicator(
                      totalSteps: questions.length,
                      currentStep: currentQues,
                      selectedColor: Colors.green,
                      // unselectedColor: Colors.yellow,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      questions[currentQues].schema!.label!,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    listOfAnswers(questions[currentQues]),
                  ],
                ),
              ),
            )
          : finalScreen(height, demoModel!),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            currentQues != -1
                ? TextButton(
                    onPressed: () {
                      if (currentQues == getRef().questions.length) {
                        setState(() {
                          ref.read(questionNoProvider.notifier).state = 0;
                          ref.read(selectedAnswerProvider.notifier).state = -1;
                          selectedCityIndex = -1;
                          selectedstateIndex = -1;
                          totalFamilyIncome.clear();
                          answers.clear();
                        });
                      } else {
                        setState(() {
                          ref.read(questionNoProvider.notifier).state--;
                          ref.read(selectedAnswerProvider.notifier).state = -1;
                          totalFamilyIncome.clear();
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.adaptive.arrow_back,
                          color: Colors.black,
                        ),
                        const Text(
                          "Back",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        )
                      ],
                    ),
                  )
                : const SizedBox(),
            currentQues <= getRef().questions.length - 1
                ? FloatingActionButton(
                    shape: const CircleBorder(),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange,
                    onPressed: () {
                      if (currentQues < getRef().questions.length - 1) {
                        setState(() {
                          ref.read(questionNoProvider.notifier).state++;
                          ref.read(selectedAnswerProvider.notifier).state = -1;

                          var quesNo = ref.read(questionNoProvider);
                          if (questions[quesNo].type == "SingleSelect") {
                            if ((answers["typeOFLoan"] as Options).key !=
                                "balance-transfer-top-up") {
                              ref.read(questionNoProvider.notifier).state++;
                              ref.read(selectedAnswerProvider.notifier).state =
                                  -1;
                            }
                          }
                        });
                      } else {
                        setState(() {
                          ref.read(questionNoProvider.notifier).state++;
                        });
                      }
                    },
                    child: Icon(Icons.adaptive.arrow_forward),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget listOfAnswers(Fields questions) {
    var selectedAns = ref.watch(selectedAnswerProvider);
    var currentQues = ref.watch(questionNoProvider);

    var schema = questions.schema!;
    List<Fields> fields = [];
    if (questions.type == "Section") {
      fields.addAll(questions.schema!.fields!);
    }

    if (questions.type == "Section" && questions.schema!.name == "Section1") {
      setState(() {
        fieldName = fields[0].schema!.name!;
      });
    }

    return (questions.type == "SingleChoiceSelector" ||
            (questions.type == "SingleSelect"))
        ? Expanded(
            child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: schema.options!.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                    border: selectedAns == index
                        ? Border.all(color: Colors.orange)
                        : Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5)),
                height: 50,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  title: Text(
                    schema.options![index].value!,
                    maxLines: 4,
                    style: TextStyle(
                      color: selectedAns == index
                          ? (Colors.orange)
                          : (Colors.black),
                    ),
                  ),
                  leading: Radio<int>(
                    value: index,
                    activeColor: (Colors.orange),
                    groupValue: selectedAns,
                    onChanged: (int? value) {
                      setState(() {
                        ref.read(selectedAnswerProvider.notifier).state =
                            value!;
                        answers[schema.name!] = schema.options![value];
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      ref.read(selectedAnswerProvider.notifier).state = index;
                      answers[schema.name!] = schema.options![index];
                    });
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
              height: 10,
            ),
          ))
        : (questions.type == "Section")
            ? (questions.schema!.name == "Section1")
                ? SizedBox(
                    height: 200,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          fields[0].schema!.label!,
                          maxLines: 4,
                          style: const TextStyle(
                            color: (Colors.black),
                          ),
                        ),
                        TextField(
                          textInputAction: TextInputAction.done,
                          controller: totalFamilyIncome,
                          inputFormatters: <TextInputFormatter>[
                            // for below version 2 use this
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            filled: false,
                            focusColor: Colors.orange,
                          ),
                        )
                      ],
                    ),
                  )
                : Expanded(
                    child: Column(
                    children: [
                      familyResources(fields[0].schema!, true),
                      familyResources(fields[1].schema!, false),
                    ],
                  ))
            : SizedBox();
  }

  Widget familyResources(Schema scheme, bool state) {
    return Column(
      children: [
        SizedBox(
          height: 14,
        ),
        Text(
          scheme!.label!,
          maxLines: 4,
          style: const TextStyle(
              color: (Colors.black), fontSize: 15, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 5,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: scheme.options!.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                  border:
                      (state ? selectedstateIndex : selectedCityIndex) == index
                          ? Border.all(color: Colors.orange)
                          : Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5)),
              height: 50,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                title: Text(
                  scheme.options![index].value!,
                  maxLines: 4,
                  style: TextStyle(
                    color: (state ? selectedstateIndex : selectedCityIndex) ==
                            index
                        ? (Colors.orange)
                        : (Colors.black),
                  ),
                ),
                leading: Radio<int>(
                  value: index,
                  activeColor: (Colors.orange),
                  groupValue: (state ? selectedstateIndex : selectedCityIndex),
                  onChanged: (int? value) {
                    setState(() {
                      (state
                          ? selectedstateIndex = value!
                          : selectedCityIndex = value!);
                      // ref.read(selectedAnswerProvider.notifier).state = value!;
                      answers[scheme.name!] = scheme.options![value];
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    (state
                        ? selectedstateIndex = index
                        : selectedCityIndex = index);
                    // ref.read(selectedAnswerProvider.notifier).state = index;
                    answers[scheme.name!] = scheme.options![index];
                    print(answers);
                  });
                },
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            height: 10,
          ),
        ),
      ],
    );
  }

  Widget finalScreen(double height, DemoModel demoModel) {
    var keys = answers.keys.toList();
    var values = answers.values.toList();
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: height,
              ),
              Text(
                demoModel!.title!,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Questions & Answers",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 500,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: answers.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return (values[index] != null)
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Q${index + 1}). ${keys[index]}",
                                    maxLines: 4,
                                    style: const TextStyle(
                                        color: (Colors.black),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    (values[index] is String)
                                        ? "Ans. ${values[index]}"
                                        : "Ans. ${(values[index] as Options).value!}",
                                    maxLines: 4,
                                    style: const TextStyle(
                                        color: (Colors.black),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
