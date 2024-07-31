import 'package:ai_chatter/config/themes/theme_cubit.dart';
import 'package:ai_chatter/core/utils/constants.dart';
import 'package:ai_chatter/features/chat/controller/repositories/base_chat_repository.dart';
import 'package:ai_chatter/features/chat/controller/usecases/cache_chat_usecase.dart';
import 'package:ai_chatter/features/chat/controller/usecases/clear_chat_history_usecase.dart';
import 'package:ai_chatter/features/chat/controller/usecases/generate_response_usecase.dart';
import 'package:ai_chatter/features/chat/controller/usecases/generate_suggestions_usecase.dart';
import 'package:ai_chatter/features/chat/controller/usecases/get_cached_chat_usecase.dart';
import 'package:ai_chatter/features/chat/model/data_sources/local/chat_local_data_source.dart';
import 'package:ai_chatter/features/chat/model/data_sources/remote/chat_remote_data_source.dart';
import 'package:ai_chatter/features/chat/model/repositories/chat_repository.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/logic/chat_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator = GetIt.instance;

Future<void> initLocator() async {
  //*External
  _initExternal();

  await locator.isReady<SharedPreferences>();

  //*Remote Services
  _initRemote();

  //*Local Services
  _initLocal();

  //*Repositories
  _initRepositories();

  //*UseCases
  _initUseCases();

  //*Cubits
  _initCubits();
}

void _initRepositories() {
  locator.registerLazySingleton<BaseChatRepository>(
    () => ChatRepository(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
}

void _initLocal() {
  locator.registerLazySingleton<BaseChatLocalDataSource>(
    () => ChatLocalDataSource(locator()),
  );
}

void _initRemote() {
  locator.registerLazySingleton<BaseChatRemoteDataSource>(
    () => ChatRemoteDataSource(locator(), locator(), locator(), locator()),
  );
}

void _initUseCases() {
  locator.registerLazySingleton<GenerateResponseUseCase>(
    () => GenerateResponseUseCase(
      locator(),
    ),
  );
  locator.registerLazySingleton<GenerateSuggestionsUseCase>(
    () => GenerateSuggestionsUseCase(
      locator(),
    ),
  );
  locator.registerLazySingleton<CacheChatUseCase>(
    () => CacheChatUseCase(
      locator(),
    ),
  );
  locator.registerLazySingleton<GetCachedChatUseCase>(
    () => GetCachedChatUseCase(
      locator(),
    ),
  );
  locator.registerLazySingleton<ClearChatHistoryUseCase>(
    () => ClearChatHistoryUseCase(
      locator(),
    ),
  );
}

void _initCubits() {
  locator.registerFactory<ThemeCubit>(
    () => ThemeCubit(
      locator(),
    ),
  );
  locator.registerFactory<ChatCubit>(
    () => ChatCubit(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
}

void _initExternal() {
  locator.registerLazySingleton<GenerativeModel>(
    () => GenerativeModel(
      model: AppConstants.modelName,
      apiKey: AppConstants.apiKey,
    ),
  );
  final ChatSession chat = locator<GenerativeModel>().startChat();
  locator.registerLazySingleton<ChatSession>(
    () => chat,
  );
  locator.registerLazySingleton<Connectivity>(
    () => Connectivity(),
  );
  locator.registerLazySingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );
}
