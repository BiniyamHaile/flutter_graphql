import 'package:challenge/cubit/add_todo/add_todo_cubit.dart';
import 'package:challenge/cubit/theme/change_theme_cubit.dart';
import 'package:challenge/theme/theme.dart';
import 'package:challenge/ui/add_todo/view/add_todo_page.dart';
import 'package:challenge/ui/home/home.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graph_repository/graph_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  const App({super.key});

  static SharedPreferences? mainSharedPreferences;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ToDosBloc>(
          create: (context) => ToDosBloc(client: client)..run(),
        ),
        BlocProvider<UpdateToDoBloc>(
          create: (context) => UpdateToDoBloc(client: client),
        ),
        BlocProvider<AddToDoBloc>(
          create: (context) => AddToDoBloc(client: client),
        ),
        BlocProvider<DeleteToDoBloc>(
          create: (context) => DeleteToDoBloc(client: client),
        ),
        BlocProvider<AddToDoCubit>(
          create: (context) => AddToDoCubit(client: client),
        ),
        BlocProvider<ChangeThemeCubit>(
          create: (context) => ChangeThemeCubit(
            mainSharedPreferences: App.mainSharedPreferences,
          ),
        ),
      ],
      child: BlocBuilder<ChangeThemeCubit, ChangeThemeState>(
        builder: (context1, ChangeThemeState themeState) {
          return MaterialApp.router(
            darkTheme: (themeState is ThemeAutoState)
                ? buildThemeData(myThemes[1])
                : (themeState is ThemeLightState)
                    ? buildThemeData(myThemes[0])
                    : buildThemeData(myThemes[1]),
            theme: (themeState is ThemeAutoState)
                ? buildThemeData(myThemes[0])
                : (themeState is ThemeLightState)
                    ? buildThemeData(myThemes[0])
                    : buildThemeData(myThemes[1]),
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            locale: context.locale,
            routerConfig: routeConfig,
          );
        },
      ),
    );
  }
}

class RouterNames {
  static const String home = '/';
  static const String addTodo = '/addTodo';
}

GoRouter routeConfig = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      name: RouterNames.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/addTodo',
      builder: (context, state) => const AddToDoPage(),
      name: RouterNames.addTodo,
    ),
  ],
);
