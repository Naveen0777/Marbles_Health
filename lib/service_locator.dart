import 'package:get_it/get_it.dart';
import 'package:marbles_health/form_model.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<FormModel>(FormModel());
}
