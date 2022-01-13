part of 'base_bloc.dart';

@immutable
abstract class BaseState {
  final List<Object>? propss;
  BaseState([this.propss]);
  @override
  List<Object> get props => (propss ?? []);

  @override
  String toString() => '$propss';
}

class BaseInitial extends BaseState {}

class BaseLoading extends BaseState {}

class BaseRefresh extends BaseState {
  BaseRefresh(data) : super(data != null ? [data] : []);
}

class BaseError extends BaseState {
  final String error;
  BaseError(this.error);
  @override
  String toString() => '$error';
}
