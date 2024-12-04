// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStore, Store {
  late final _$loadingAtom = Atom(name: '_AuthStore.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$hasSessionAtom =
      Atom(name: '_AuthStore.hasSession', context: context);

  @override
  bool get hasSession {
    _$hasSessionAtom.reportRead();
    return super.hasSession;
  }

  @override
  set hasSession(bool value) {
    _$hasSessionAtom.reportWrite(value, super.hasSession, () {
      super.hasSession = value;
    });
  }

  late final _$successAtom = Atom(name: '_AuthStore.success', context: context);

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  late final _$signInWithGoogleAsyncAction =
      AsyncAction('_AuthStore.signInWithGoogle', context: context);

  @override
  Future<void> signInWithGoogle() {
    return _$signInWithGoogleAsyncAction.run(() => super.signInWithGoogle());
  }

  late final _$logOutAsyncAction =
      AsyncAction('_AuthStore.logOut', context: context);

  @override
  Future<void> logOut() {
    return _$logOutAsyncAction.run(() => super.logOut());
  }

  @override
  String toString() {
    return '''
loading: ${loading},
hasSession: ${hasSession},
success: ${success}
    ''';
  }
}
