// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$timelineRepositoryHash() =>
    r'692ca9c1fd75a0132e0cfc657562050ea0099783';

/// See also [timelineRepository].
@ProviderFor(timelineRepository)
final timelineRepositoryProvider =
    AutoDisposeProvider<TimelineRepository>.internal(
  timelineRepository,
  name: r'timelineRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$timelineRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TimelineRepositoryRef = AutoDisposeProviderRef<TimelineRepository>;
String _$timelineHash() => r'c667aeaa96dd6c597ff4d5504d134c686559c63e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [timeline].
@ProviderFor(timeline)
const timelineProvider = TimelineFamily();

/// See also [timeline].
class TimelineFamily extends Family<AsyncValue<List<TimelineItem>>> {
  /// See also [timeline].
  const TimelineFamily();

  /// See also [timeline].
  TimelineProvider call(
    String memoryId,
  ) {
    return TimelineProvider(
      memoryId,
    );
  }

  @override
  TimelineProvider getProviderOverride(
    covariant TimelineProvider provider,
  ) {
    return call(
      provider.memoryId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'timelineProvider';
}

/// See also [timeline].
class TimelineProvider extends AutoDisposeStreamProvider<List<TimelineItem>> {
  /// See also [timeline].
  TimelineProvider(
    String memoryId,
  ) : this._internal(
          (ref) => timeline(
            ref as TimelineRef,
            memoryId,
          ),
          from: timelineProvider,
          name: r'timelineProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$timelineHash,
          dependencies: TimelineFamily._dependencies,
          allTransitiveDependencies: TimelineFamily._allTransitiveDependencies,
          memoryId: memoryId,
        );

  TimelineProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.memoryId,
  }) : super.internal();

  final String memoryId;

  @override
  Override overrideWith(
    Stream<List<TimelineItem>> Function(TimelineRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TimelineProvider._internal(
        (ref) => create(ref as TimelineRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        memoryId: memoryId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<TimelineItem>> createElement() {
    return _TimelineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TimelineProvider && other.memoryId == memoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, memoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TimelineRef on AutoDisposeStreamProviderRef<List<TimelineItem>> {
  /// The parameter `memoryId` of this provider.
  String get memoryId;
}

class _TimelineProviderElement
    extends AutoDisposeStreamProviderElement<List<TimelineItem>>
    with TimelineRef {
  _TimelineProviderElement(super.provider);

  @override
  String get memoryId => (origin as TimelineProvider).memoryId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
