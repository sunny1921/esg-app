import 'package:esg_post_office/core/providers/navigation_provider.dart';
import 'package:esg_post_office/core/widgets/bottom_nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esg_post_office/core/theme/app_theme.dart';
import 'package:esg_post_office/features/auth/presentation/pages/splash_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.setSettings(
    appVerificationDisabledForTesting: false,
    phoneNumber: null,
    smsCode: null,
    forceRecaptchaFlow: true,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showBottomNav = ref.watch(bottomNavVisibilityProvider);
    final currentIndex = ref.watch(navigationProvider);

    return MaterialApp(
      title: 'ESG Post Office',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const SplashScreen(),
            );
          },
        ),
        bottomNavigationBar: showBottomNav
            ? BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (index) =>
                    ref.read(navigationProvider.notifier).setIndex(index),
                selectedItemColor: const Color(0xFF1B5E20),
                unselectedItemColor: Colors.grey,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.scale),
                    label: 'Record',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.notifications),
                    label: 'Notifications',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.energy_savings_leaf),
                    label: 'Carbon Credits',
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
