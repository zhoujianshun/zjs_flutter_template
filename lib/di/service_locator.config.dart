// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:zjs_flutter_template/core/monitoring/interfaces/analytics_interface.dart'
    as _i849;
import 'package:zjs_flutter_template/core/monitoring/interfaces/error_monitor_interface.dart'
    as _i451;
import 'package:zjs_flutter_template/core/monitoring/interfaces/performance_monitor_interface.dart'
    as _i740;
import 'package:zjs_flutter_template/core/monitoring/mock_analytics_service.dart'
    as _i725;
import 'package:zjs_flutter_template/core/monitoring/mock_error_monitor.dart'
    as _i140;
import 'package:zjs_flutter_template/core/monitoring/mock_performance_monitor.dart'
    as _i785;
import 'package:zjs_flutter_template/core/network/api_client.dart' as _i742;
import 'package:zjs_flutter_template/core/network/base_api.dart' as _i158;
import 'package:zjs_flutter_template/core/network/network_info.dart' as _i814;
import 'package:zjs_flutter_template/core/storage/storage_service.dart'
    as _i232;
import 'package:zjs_flutter_template/di/service_locator.dart' as _i1001;
import 'package:zjs_flutter_template/shared/apis/example_api.dart' as _i884;
import 'package:zjs_flutter_template/shared/apis/user_api.dart' as _i590;
import 'package:zjs_flutter_template/shared/services/user_service.dart'
    as _i670;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.singletonAsync<_i232.StorageService>(
      () => registerModule.storageService,
      preResolve: true,
    );
    gh.singleton<_i742.ApiClient>(() => registerModule.apiClient);
    gh.singleton<_i814.NetworkInfo>(() => _i814.NetworkInfo());
    gh.singleton<_i740.IPerformanceMonitor>(
        () => _i785.MockPerformanceMonitor());
    gh.singleton<_i451.IErrorMonitor>(() => _i140.MockErrorMonitor());
    gh.factory<_i884.CreateExampleRequest>(() => _i884.CreateExampleRequest(
          name: gh<String>(),
          description: gh<String>(),
        ));
    gh.singleton<_i849.IAnalyticsService>(() => _i725.MockAnalyticsService());
    gh.factory<_i884.UpdateExampleRequest>(() => _i884.UpdateExampleRequest(
          name: gh<String>(),
          description: gh<String>(),
        ));
    gh.factory<_i158.PaginatedResponse<dynamic>>(
        () => _i158.PaginatedResponse<dynamic>(
              items: gh<List<dynamic>>(),
              total: gh<int>(),
              page: gh<int>(),
              pageSize: gh<int>(),
              hasMore: gh<bool>(),
            ));
    gh.factory<_i590.UserAPI>(() => _i590.UserAPI(gh<_i742.ApiClient>()));
    gh.factory<_i884.ExampleAPI>(() => _i884.ExampleAPI(gh<_i742.ApiClient>()));
    gh.factory<_i884.ExampleModel>(() => _i884.ExampleModel(
          id: gh<String>(),
          name: gh<String>(),
          description: gh<String>(),
          createdAt: gh<DateTime>(),
        ));
    gh.singleton<_i670.UserService>(() => _i670.UserServiceImpl(
          userApi: gh<_i590.UserAPI>(),
          storageService: gh<_i232.StorageService>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i1001.RegisterModule {}
