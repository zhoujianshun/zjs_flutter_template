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
import 'package:sky_eldercare_family/core/network/network_info.dart' as _i356;
import 'package:sky_eldercare_family/core/storage/storage_service.dart'
    as _i540;
import 'package:sky_eldercare_family/di/service_locator.dart' as _i40;
import 'package:sky_eldercare_family/shared/repositories/auth_repository.dart'
    as _i462;
import 'package:sky_eldercare_family/shared/repositories/auth_repository_impl.dart'
    as _i647;
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
    gh.singleton<_i454.UserService>(
        () => _i454.UserServiceImpl(gh<_i557.ApiClient>()));
    gh.singleton<_i462.AuthRepository>(() => _i647.AuthRepositoryImpl(
          userService: gh<_i454.UserService>(),
          storageService: gh<_i540.StorageService>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i40.RegisterModule {}
