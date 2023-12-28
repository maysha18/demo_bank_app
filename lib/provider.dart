import 'package:demo_project/data/demo_Data.dart';
import 'package:demo_project/models/demo_model.dart';
import 'package:demo_project/widgets/snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final demoControllerNotifier = NotifierProvider(() => DemoController());

class DemoController extends Notifier {
  List<Fields> questions = [];
  DemoModel? demoModel;
  @override
  build() {
    demoModelParsingProvider();
  }

  demoModelParsingProvider() async {
    try {
      demoModel = DemoModel.fromJson(dummyData);
      questions.addAll(demoModel!.schema!.fields!);
    } catch (exception) {
      SnackBarUtils.showSnackBars(msg: exception.toString());
    }
  }
}

final selectedAnswerProvider = StateProvider<int>((ref) => -1);
final questionNoProvider = StateProvider<int>((ref) => 0);
