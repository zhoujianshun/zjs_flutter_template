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
import 'package:sky_eldercare_family/core/network/api_client.dart' as _i557;
import 'package:sky_eldercare_family/core/network/base_api.dart' as _i481;
import 'package:sky_eldercare_family/core/network/network_info.dart' as _i356;
import 'package:sky_eldercare_family/core/storage/storage_service.dart'
    as _i540;
import 'package:sky_eldercare_family/di/service_locator.dart' as _i40;
import 'package:sky_eldercare_family/shared/apis/example_api.dart' as _i295;
import 'package:sky_eldercare_family/shared/apis/user_api.dart' as _i633;
import 'package:sky_eldercare_family/shared/services/user_service.dart'
    as _i454;

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
    await gh.singletonAsync<_i540.StorageService>(
      () => registerModule.storageService,
      preResolve: true,
    );
    gh.singleton<_i557.ApiClient>(() => registerModule.apiClient);
    gh.singleton<_i356.NetworkInfo>(() => _i356.NetworkInfo());
    gh.factory<_i633.UserAPI>(() => _i633.UserAPI(gh<_i557.ApiClient>()));
    gh.factory<_i295.ExampleAPI>(() => _i295.ExampleAPI(gh<_i557.ApiClient>()));
    gh.factory<_i295.CreateExampleRequest>(() => _i295.CreateExampleRequest(
          name: gh<String>(),
          description: gh<String>(),
        ));
    gh.factory<_i295.UpdateExampleRequest>(() => _i295.UpdateExampleRequest(
          name: gh<String>(),
          description: gh<String>(),
        ));
    gh.factory<_i481.PaginatedResponse<dynamic>>(
        () => _i481.PaginatedResponse<dynamic>(
              items: gh<List<dynamic>>(),
              total: gh<int>(),
              page: gh<int>(),
              pageSize: gh<int>(),
              hasMore: gh<bool>(),
            ));
    gh.singleton<_i454.UserService>(() => _i454.UserServiceImpl(
          userApi: gh<_i633.UserAPI>(),
          storageService: gh<_i540.StorageService>(),
        ));
    gh.factory<_i295.ExampleModel>(() => _i295.ExampleModel(
          id: gh<String>(),
          name: gh<String>(),
          description: gh<String>(),
          createdAt: gh<DateTime>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i40.RegisterModule {}
