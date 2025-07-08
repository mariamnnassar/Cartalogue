// lib/core/localization/locale_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to hold and update the app's current locale
final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));
