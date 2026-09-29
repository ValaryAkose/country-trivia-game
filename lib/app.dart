import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasources/remote/countries_remote_data_source.dart';
import 'data/datasources/local/game_local_data_source.dart';
import 'data/repositories/country_repository_impl.dart';
import 'data/repositories/game_repository_impl.dart';
import 'domain/repositories/country_repository.dart';
import 'domain/repositories/game_repository.dart';
import 'domain/usecases/fetch_countries.dart';
import 'domain/usecases/generate_question.dart';
import 'domain/usecases/submit_answer.dart';
import 'domain/usecases/start_new_game.dart';
import 'domain/usecases/reset_game.dart';
import 'presentation/providers/game_provider.dart';
import 'presentation/screens/home_screen.dart';
import 'theme/app_theme.dart';

class TriviaApp extends StatelessWidget {
  final SharedPreferences prefs;

  const TriviaApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<http.Client>(
          create: (_) => http.Client(),
        ),
        Provider<GameRepository>(
          create: (_) => GameRepositoryImpl(
            localDataSource: GameLocalDataSourceImpl(prefs: prefs),
          ),
        ),
        Provider<CountryRepository>(
          create: (context) => CountryRepositoryImpl(
            remoteDataSource: CountriesRemoteDataSourceImpl(
              client: context.read<http.Client>(),
            ),
          ),
        ),
        ChangeNotifierProvider<GameProvider>(
          create: (context) => GameProvider(
            fetchCountriesUseCase: FetchCountries(context.read<CountryRepository>()),
            generateQuestionUseCase: GenerateQuestion(),
            submitAnswerUseCase: SubmitAnswer(),
            startNewGameUseCase: StartNewGame(),
            resetGameUseCase: ResetGame(),
            countryRepository: context.read<CountryRepository>(),
            gameRepository: context.read<GameRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Country Trivia',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
