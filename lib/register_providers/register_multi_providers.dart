import 'package:bab_stories_app/features/news_feature/presentation/providers/NetworkProvider.dart';
import 'package:provider/provider.dart';

final providers = [
  ChangeNotifierProvider(
    create: (_) => NetworkProvider(),
    lazy: true,
  ),
];
