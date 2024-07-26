import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:step_counter_app/cubit_navigation/navigation_cubit.dart';
import 'package:step_counter_app/cubit_permission/permission_cubit.dart';
import 'package:step_counter_app/data/model/step_data.dart';
import 'package:step_counter_app/screens/home/home.dart';
import 'package:step_counter_app/screens/report/report.dart';
import 'package:step_counter_app/service/step_service.dart';

void main() async {
  //Arka plan izinleri
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterBackground.initialize(
    androidConfig: const FlutterBackgroundAndroidConfig(
      notificationTitle: "Adım Sayar",
      notificationText: "Adım sayımı aktif",
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon:
          AndroidResource(name: 'background_icon', defType: 'drawable'),
    ),
  );
  await FlutterBackground.enableBackgroundExecution();
  //Veritabanı işlemleri
  await Hive.initFlutter();
  Hive.registerAdapter(StepDataAdapter());
  await Hive.openBox<StepData>('stepDataBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final StepService stepService = StepService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationCubit>(
            create: (context) => NavigationCubit(stepService)),
        BlocProvider<PermissionCubit>(
            create: (context) => PermissionCubit()..requestPermissions()),
      ],
      child: MaterialApp(
        title: 'AdımSayar-Pedometre',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: const TextTheme(
            labelSmall: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController = PageController();

  //Uygulama ilk açıldığında çalışması gereken fonksiyonlar
  @override
  void initState() {
    super.initState();
    context.read<NavigationCubit>().initPlatformState();
    context.read<NavigationCubit>().resetStepsAtMidnight();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PermissionCubit, PermissionState>(
        builder: (context, permissionState) {
          if (permissionState.isGranted) {
            return BlocBuilder<NavigationCubit, NavigationState>(
              builder: (context, navState) {
                return PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    context.read<NavigationCubit>().setSelectedIndex(index);
                  },
                  children: const [
                    Home(),
                    Report(),
                  ],
                );
              },
            );
          } else {
            return Center(child: Text(permissionState.message));
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return NavigationBar(
              backgroundColor: const Color(0xff224A88),
              destinations: const [
                NavigationDestination(
                  icon: Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                  ),
                  label: "Home",
                  selectedIcon: Icon(Icons.home),
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.query_stats_outlined,
                    color: Colors.white,
                  ),
                  label: "Report",
                  selectedIcon: Icon(
                    Icons.query_stats,
                  ),
                ),
              ],
              selectedIndex: state.selectedIndex,
              onDestinationSelected: (value) {
                _pageController.jumpToPage(value);
                context.read<NavigationCubit>().setSelectedIndex(value);
              });
        },
      ),
    );
  }
}
