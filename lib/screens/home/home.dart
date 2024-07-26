import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_counter_app/cubit_permission/permission_cubit.dart';
import 'package:step_counter_app/screens/home/widgets/daily_average.dart';
import 'package:step_counter_app/screens/home/widgets/dashboard_card.dart';
import 'package:step_counter_app/cubit_navigation/navigation_cubit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _initialize() {
    context.read<PermissionCubit>().requestPermissions();
    context.read<NavigationCubit>().initPlatformState();
    context.read<NavigationCubit>().resetStepsAtMidnight();
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionCubit, PermissionState>(
      builder: (context, state) {
        if (state.isGranted) {
          return BlocBuilder<NavigationCubit, NavigationState>(
            builder: (context, navState) {
              return Scaffold(
                body: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xff0C1E4E),
                            Color(0xff224A88),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: kToolbarHeight,
                            ),
                            DashboardCard(navState.steps, navState.miles,
                                navState.calories, navState.duration),
                            const SizedBox(height: 10),
                            const DailyAverage(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return Scaffold(
            body: Center(
              child: Text(state.message),
            ),
          );
        }
      },
    );
  }
}
