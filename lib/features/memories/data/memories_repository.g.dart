// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memories_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$memoriesRepositoryHash() =>
    r'4460d7b82be4271d90ce31339fcdc4b816bf0705';

/// See also [memoriesRepository].
@ProviderFor(memoriesRepository)
final memoriesRepositoryProvider =
    AutoDisposeProvider<MemoriesRepository>.internal(
  memoriesRepository,
  name: r'memoriesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$memoriesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MemoriesRepositoryRef = AutoDisposeProviderRef<MemoriesRepository>;
String _$memoriesHash() => r'4f694da57c94f405606b34bc46a72db78982deec';

/// See also [memories].
@ProviderFor(memories)
final memoriesProvider = AutoDisposeStreamProvider<List<Memory>>.internal(
  memories,
  name: r'memoriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$memoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MemoriesRef = AutoDisposeStreamProviderRef<List<Memory>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
