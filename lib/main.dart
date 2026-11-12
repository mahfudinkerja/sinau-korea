import 'package:flutter/material.dart';

import 'screens/root_shell.dart';
import 'services/app_state.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  await state.load();
  runApp(VolingoApp(state: state));
}

class VolingoApp extends StatelessWidget {
  final AppState state;
  const VolingoApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return MaterialApp(
          title: 'Volingo Korean',
          debugShowCheckedModeBanner: false,
          theme: buildLightTheme(),
          darkTheme: buildAppTheme(),
          themeMode: state.themeMode,
          builder: (context, child) {
            AppColors.apply(Theme.of(context).brightness);
            return child ?? const SizedBox.shrink();
          },
          home: RootShell(state: state),
        );
      },
    );
  }
}
