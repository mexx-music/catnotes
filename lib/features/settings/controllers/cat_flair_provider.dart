import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 0=aus, 1=leicht (default), 2=mittel, 3=mehr
final catFlairProvider = StateProvider<int>((ref) => 1);

