import 'package:clean_riverpod/core/widgets/async_value_view.dart';
import 'package:clean_riverpod/main_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (details) => AppErrorWidget(details: details);

  runApp(const ProviderScope(child: MyApp()));
}
