import 'package:autoroute_app/ignore/core/interceptors/interceptors_dart.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

abstract class HttpClientInjectableModule {
  // @LazySingleton(as: http.Client)
  // @Deprecated('migration')
  // @lazySingleton
  http.Client get client => http.Client();
}

class RepositoryImpl {
  var url = 'http://example.com/articles';
  var httpClient =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);
  fetchEntries() async {
    var url = 'https://api.publicapis.org/entries';
    await httpClient.get(Uri.parse(url));
  }
}
