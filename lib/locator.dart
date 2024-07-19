import 'package:ai_chatter/config/themes/theme_cubit.dart';
import 'package:ai_chatter/core/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator = GetIt.instance;

Future<void> initLocator() async {
  //*External
  locator.registerLazySingleton<GenerativeModel>(
    () => GenerativeModel(
      model: AppConstants.modelName,
      apiKey: AppConstants.apiKey,
    ),
  );
  locator.registerLazySingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );

  await locator.isReady<SharedPreferences>();

  //*Cubits
  locator.registerFactory<ThemeCubit>(
    () => ThemeCubit(
      locator(),
    ),
  );
}
