import 'package:bab_stories_app/providers/NetworkProvider.dart';
import 'package:provider/provider.dart';

final providers = [
  ChangeNotifierProvider(
    create: (_) => NetworkProvider(),
    lazy: true,
  ),
];
