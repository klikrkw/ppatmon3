import 'package:equatable/equatable.dart';

import 'package:newklikrkw/enums/postingjurnal_filter_range.dart';
import 'package:newklikrkw/models/requests/add_postingjurnal_request.dart';
import 'package:newklikrkw/models/requests/update_postingjurnal_request.dart';

abstract class PostingjurnalEvent extends Equatable {
  const PostingjurnalEvent();

  @override
  List<Object?> get props => [];
}

///================================================
/// Load Pertama
///================================================

class LoadPostingjurnals extends PostingjurnalEvent {
  const LoadPostingjurnals();
}

///================================================
/// Refresh
///================================================

class RefreshPostingjurnals extends PostingjurnalEvent {
  const RefreshPostingjurnals();
}

///================================================
/// Infinite Scroll
///================================================

class LoadMorePostingjurnals extends PostingjurnalEvent {
  const LoadMorePostingjurnals();
}

///================================================
/// Filter Range
///================================================

class ChangePostingjurnalFilterRange extends PostingjurnalEvent {
  final PostingjurnalFilterRange range;

  const ChangePostingjurnalFilterRange(this.range);

  @override
  List<Object?> get props => [range];
}

///================================================
/// Filter Periode
///================================================

class ChangePostingjurnalPeriod extends PostingjurnalEvent {
  final DateTime startDate;
  final DateTime endDate;

  const ChangePostingjurnalPeriod({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

///================================================
/// Reset Filter
///================================================

class ResetPostingjurnalFilter extends PostingjurnalEvent {
  const ResetPostingjurnalFilter();
}

/// ===============================
/// Load Daftar Akun
/// ===============================
class LoadAkuns extends PostingjurnalEvent {
  const LoadAkuns();
}

/// ===============================
/// Add
/// ===============================
class AddPostingjurnal extends PostingjurnalEvent {
  final AddPostingjurnalRequest request;

  const AddPostingjurnal(this.request);

  @override
  List<Object?> get props => [request];
}

/// ===============================
/// Update
/// ===============================
class UpdatePostingjurnal extends PostingjurnalEvent {
  final String id;
  final UpdatePostingjurnalRequest request;

  const UpdatePostingjurnal(this.id, this.request);

  @override
  List<Object?> get props => [id, request];
}

/// ===============================
/// Reset Validation Error
/// ===============================
class ResetValidationError extends PostingjurnalEvent {
  const ResetValidationError();
}

/// ===============================
/// Reset Save State
/// ===============================
class ResetSaveState extends PostingjurnalEvent {
  const ResetSaveState();
}

class DeletePostingjurnal extends PostingjurnalEvent {
  final String id;

  const DeletePostingjurnal(this.id);

  @override
  List<Object> get props => [id];
}

/// ===============================
/// Reset Delete State
/// ===============================
class ResetDeleteState extends PostingjurnalEvent {
  const ResetDeleteState();
}

class ResetPostingjurnalState extends PostingjurnalEvent {
  const ResetPostingjurnalState();
}
