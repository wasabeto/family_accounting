import 'package:family_accounting/services/LocalStorageService.dart';
import 'package:get_it/get_it.dart';
GetIt locator = GetIt.instance;

void setupLocator() async {
  locator.registerSingletonAsync<LocalStorageService>(() {
    final localStorageService = LocalStorageService();
    return localStorageService.getInstance();
  });
}