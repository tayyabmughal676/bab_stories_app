import 'package:bab_stories_app/features/news_feature/presentation/providers/news_provider.dart';
import 'package:provider/provider.dart';

final providers = [
  ChangeNotifierProvider(
    create: (_) => NewsProvider(),
    lazy: true,
  ),
];
